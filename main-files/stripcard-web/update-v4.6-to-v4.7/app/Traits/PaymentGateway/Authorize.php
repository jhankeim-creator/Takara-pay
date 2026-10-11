<?php
namespace App\Traits\PaymentGateway;

use App\Constants\NotificationConst;
use Exception;
use App\Models\TemporaryData;
use App\Http\Helpers\Api\Helpers;
use App\Constants\PaymentGatewayConst;
use App\Http\Helpers\PushNotificationHelper;
use App\Models\Admin\PaymentGateway;
use App\Models\UserNotification;
use App\Models\UserWallet;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Traits\AdminNotifications\AddMoneyNotifications;
use Jenssegers\Agent\Agent;

trait Authorize{

    use AddMoneyNotifications;

    public function authorizeInit($output = null){
        if(!$output) $output = $this->output;
        if($output['type'] === PaymentGatewayConst::TYPEADDMONEY){
            return $this->setupAuthorizeInitAddMoney($output);
        }
    }

    public function setupAuthorizeInitAddMoney($output,){
        $junk_data = $this->authorizeJunkInsert();
        if(request()->expectsJson()) {
            $this->output['redirection_response'] = [];
            $this->output['redirect_links']       = [];
            $this->output['gateway_alias']        = "authorize";
            $this->output['identifier']           = $junk_data->identifier ?? '';
            $this->output['redirect_url']         = route('api.user.add.money.authorize.payment.submit');

            return $this->get();
        }
        return redirect()->route('user.add.money.authorize.card.info',$junk_data->identifier);
    }
    public function authorizeJunkInsert() {
        $output = $this->output;
        $temp_record_token = generate_unique_string('temporary_datas', 'identifier', 60);

        $data = [
            'gateway'       => $output['gateway']->id,
            'currency'      => $output['currency']->id,
            'amount'        => json_decode(json_encode($output['amount']),true),
            'wallet_table'  => $output['wallet']->getTable(),
            'wallet_id'     => $output['wallet']->id,
            'creator_table' => auth()->guard(get_auth_guard())->user()->getTable(),
            'creator_id'    => auth()->guard(get_auth_guard())->user()->id,
            'creator_guard' => get_auth_guard(),
            'source'        => $output['request_data']['source'] ?? null,
            'success_url'   => $output['request_data']['success_url'] ?? null,
            'cancel_url'    => $output['request_data']['cancel_url'] ?? null,
        ];

        return TemporaryData::create([
            'type'          => PaymentGatewayConst::AUTHORIZE,
            'identifier'    => $temp_record_token,
            'data'          => $data,
        ]);
    }
    public function authorizeInitApi($output = null){
        if(!$output) $output = $this->output;
        if($output['type'] === PaymentGatewayConst::TYPEADDMONEY){
            return $this->setupAuthorizeInitAddMoney($output);
        }
    }

    // For get the gateway credentials
    function authorizeCredentials($temp_data){
        $gateway             = PaymentGateway::where('id',$temp_data->data->gateway)->first() ?? null;
        if(!$gateway) throw new Exception(__("Payment gateway not available"));
        $credentials         = $gateway->credentials;
        $app_login_id        = getPaymentCredentials($credentials,'App Login ID');
        $transaction_key     = getPaymentCredentials($credentials,'Transaction Key');
        $signature_key       = getPaymentCredentials($credentials,'Signature Key');

        $mode           = $gateway->env;

        $authorize_register_mode = [
            PaymentGatewayConst::ENV_SANDBOX => "sandbox",
            PaymentGatewayConst::ENV_PRODUCTION => "live",
        ];
        if(array_key_exists($mode,$authorize_register_mode)) {
            $mode = $authorize_register_mode[$mode];
        }else {
            $mode = "sandbox";
        }

        return (object) [
            'app_login_id'          => $app_login_id,
            'transaction_key'       => $transaction_key,
            'signature_key'         => $signature_key,
            'mode'                  => $mode,
            'code'                  => $gateway->code
        ];
    }

    public function authorizeSuccess($output) {
        $output['capture']      = $output['tempData']['data']->response ?? "";

        // need to insert new transaction in database
        try{
            $this->createTransactionAuthorize($output);
        }catch(Exception $e) {
            throw new Exception($e->getMessage());
        }
    }

    // Fro insert data in db
    function createTransactionAuthorize($output){
        $trx_id = 'AM'.getTrxNum();
        $user_id = auth()->user()->id;
        $wallet  = UserWallet::where('id',$output['wallet']->id)->first();
        $gateway = PaymentGateway::where('id',$output['gateway']->id)->first();

        $inserted_id = $this->insertRecordAuthorize($output,$trx_id,$user_id,$wallet,$gateway);
        $this->insertChargesAuthorize($output,$inserted_id);
        $this->adminNotification($trx_id,$output,PaymentGatewayConst::STATUSSUCCESS);
        $this->insertDeviceAuthorize($output,$inserted_id);
        $this->removeTempDataAuthorize($output);

    }
    public function updateWalletBalanceAuthorize($output,$wallet) {
        $update_amount = $output['wallet']->balance + $output['amount']->requested_amount;
        $wallet->update([
            'balance'   => $update_amount,
        ]);
    }

    public function insertRecordAuthorize($output,$trx_id,$user_id,$wallet,$gateway){
        $status = PaymentGatewayConst::STATUSSUCCESS;
        DB::beginTransaction();
        try{
            $id = DB::table("transactions")->insertGetId([
                'user_id'                       => $user_id,
                'user_wallet_id'                => $output['wallet']->id,
                'payment_gateway_currency_id'   => $output['currency']->id,
                'type'                          => PaymentGatewayConst::TYPEADDMONEY,
                'trx_id'                        => $trx_id,
                'request_amount'                => $output['amount']->requested_amount,
                'payable'                       => $output['amount']->total_amount,
                'available_balance'             => $output['wallet']->balance + $output['amount']->requested_amount,
                'remark'                        => ucwords(remove_speacial_char(PaymentGatewayConst::TYPEADDMONEY," ")) . " With " . $gateway->name,
                'details'                       => PaymentGatewayConst::AUTHORIZE." payment successful",
                'status'                        => $status,
                'attribute'                     => PaymentGatewayConst::SEND,
                'created_at'                    => now(),
            ]);
            if($status == PaymentGatewayConst::STATUSSUCCESS){
                $this->updateWalletBalanceAuthorize($output,$wallet);
            }
            DB::commit();
        }catch(Exception $e) {
            DB::rollBack();
            throw new Exception(__("Something went wrong! Please try again."));
        }
        return $id;
    }

    public function isAuthorize($gateway)
    {
        $search_keyword = ['authorize','authorize gateway','gateway authorize','authorize payment gateway'];
        $gateway_name = $gateway->name;

        $search_text = Str::lower($gateway_name);
        $search_text = preg_replace("/[^A-Za-z0-9]/","",$search_text);
        foreach($search_keyword as $keyword) {
            $keyword = Str::lower($keyword);
            $keyword = preg_replace("/[^A-Za-z0-9]/","",$keyword);
            if($keyword == $search_text) {
                return true;
                break;
            }
        }
        return false;
    }

    public function insertChargesAuthorize($output,$id) {
        DB::beginTransaction();
        try{
            DB::table('transaction_charges')->insert([
                'transaction_id'    => $id,
                'percent_charge'    => $output['amount']->percent_charge,
                'fixed_charge'      => $output['amount']->fixed_charge,
                'total_charge'      => $output['amount']->total_charge,
                'created_at'        => now(),
            ]);
            DB::commit();

            //notification
            $notification_content = [
                'title'         => "Add Money",
                'message'       => "Your Wallet"." (".$output['wallet']->currency->code.")  "."balance  has been added"." ".$output['amount']->requested_amount.' '. $output['wallet']->currency->code,
                'time'          => Carbon::now()->diffForHumans(),
                'image'         => files_asset_path('profile-default'),
            ];

            UserNotification::create([
                'type'      => NotificationConst::BALANCE_ADDED,
                'user_id'  =>  auth()->user()->id,
                'message'   => $notification_content,
            ]);
            try{
                (new PushNotificationHelper())->prepare([auth()->user()->id],[
                    'title' => $notification_content['title'],
                    'desc'  => $notification_content['message'],
                    'user_type' => 'user',
                ])->send();
            }catch(Exception $e) {}
        }catch(Exception $e) {
            DB::rollBack();
            throw new Exception(__('Something went wrong! Please try again'));
        }
    }

    public function insertDeviceAuthorize($output,$id) {
        $client_ip = request()->ip() ?? false;
        $location = geoip()->getLocation($client_ip);
        $agent = new Agent();

        $mac = "";

        DB::beginTransaction();
        try{
            DB::table("transaction_devices")->insert([
                'transaction_id'=> $id,
                'ip'            => $client_ip,
                'mac'           => $mac,
                'city'          => $location['city'] ?? "",
                'country'       => $location['country'] ?? "",
                'longitude'     => $location['lon'] ?? "",
                'latitude'      => $location['lat'] ?? "",
                'timezone'      => $location['timezone'] ?? "",
                'browser'       => $agent->browser() ?? "",
                'os'            => $agent->platform() ?? "",
            ]);
            DB::commit();
        }catch(Exception $e) {
            DB::rollBack();
            throw new Exception(__('Something went wrong! Please try again'));
        }
    }


    public function removeTempDataAuthorize($output) {
        TemporaryData::where("identifier",$output['tempData']['identifier'])->delete();
    }
}

?>
