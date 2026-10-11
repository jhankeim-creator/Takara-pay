<?php

namespace App\Http\Controllers\Api\User;

use Exception;
use App\Models\UserWallet;
use App\Models\Transaction;
use Illuminate\Http\Request;
use App\Models\TemporaryData;
use App\Constants\GlobalConst;
use App\Models\Admin\Currency;
use Illuminate\Support\Carbon;
use App\Models\UserNotification;
use App\Http\Helpers\Api\Helpers;
use Illuminate\Support\Facades\DB;
use App\Models\Admin\BasicSettings;
use App\Constants\NotificationConst;
use App\Http\Controllers\Controller;
use App\Models\Admin\PaymentGateway;
use App\Traits\PaymentGateway\Tatum;
use Illuminate\Support\Facades\Auth;
use App\Traits\PaymentGateway\Manual;
use App\Traits\PaymentGateway\Stripe;
use App\Constants\PaymentGatewayConst;
use App\Http\Helpers\PaymentGatewayApi;
use App\Models\Admin\CryptoTransaction;
use App\Traits\PaymentGateway\Authorize;
use Illuminate\Support\Facades\Validator;
use App\Models\Admin\PaymentGatewayCurrency;
use net\authorize\api\contract\v1 as AnetAPI;
use KingFlamez\Rave\Facades\Rave as Flutterwave;
use net\authorize\api\controller as AnetController;
use App\Http\Helpers\PaymentGateway as PaymentGatewayHelper;
use Illuminate\Http\JsonResponse;

class AddMoneyController extends Controller
{
    use Stripe,Manual,Tatum,Authorize;
    public function addMoneyInformation(){
        $user = auth()->user();
        $userWallet = UserWallet::where('user_id',$user->id)->get()->map(function($data){
            return[
                'balance' => getAmount($data->balance,get_wallet_precision()),
                'currency' => get_default_currency_code(),
            ];
            })->first();
            $transactions = Transaction::auth()->addMoney()->latest()->take(5)->get()->map(function($item){
                $statusInfo = [
                    "success" =>      1,
                    "pending" =>      2,
                    "rejected" =>     3,
                ];
                return[
                    'id'               => $item->id,
                    'trx'              => $item->trx_id,
                    'gateway_name'     => $item->currency->name,
                    'transaction_type' => $item->type,
                    'request_amount'   => get_amount(@$item->request_amount,get_default_currency_code(),get_wallet_precision()),
                    'payable'          => isCrypto($item->payable,$item->currency->currency_code??get_default_currency_code(),@$item->currency->gateway->crypto),
                    'exchange_rate'    => '1 ' .get_default_currency_code().' = '.isCrypto(@$item->currency->rate??1,$item->currency->currency_code??get_default_currency_code(),$item->currency->gateway->crypto),
                    'total_charge'     => isCrypto($item->charge->total_charge??0,$item->currency->currency_code??get_default_currency_code(),@$item->currency->gateway->crypto),
                    'current_balance'  => get_amount(@$item->available_balance,get_default_currency_code(),get_wallet_precision()),
                    "confirm"          => $item->confirm??false,
                    "dynamic_inputs"   => $item->dynamic_inputs,
                    "confirm_url"      => $item->confirm_url,
                    'status'           => $item->stringStatus->value,
                    'date_time'        => $item->created_at,
                    'status_info'      => (object) $statusInfo,
                    'rejection_reason' => $item->reject_reason ?? "",

                ];
                });


        $gateways = PaymentGateway::where('status', 1)->where('slug', PaymentGatewayConst::add_money_slug())->get()->map(function($gateway){
            $currencies = PaymentGatewayCurrency::where('payment_gateway_id',$gateway->id)->get()->map(function($data){
                $precision = get_precision($data->gateway);
                return[
                        'id'                    => $data->id,
                        'payment_gateway_id'    => $data->payment_gateway_id,
                        'crypto'                => $data->gateway->crypto,
                        'type'                  => $data->gateway->type,
                        'name'                  => $data->name,
                        'alias'                 => $data->alias,
                        'currency_code'         => $data->currency_code,
                        'currency_symbol'       => $data->currency_symbol,
                        'image'                 => $data->image,
                        'min_limit'             => $data->min_limit,
                        'max_limit'             => $data->max_limit,
                        'percent_charge'        => $data->percent_charge,
                        'fixed_charge'          => $data->fixed_charge,
                        'daily_limit'           => $data->daily_limit,
                        'monthly_limit'         => $data->monthly_limit,
                        'rate'                  => $data->rate,
                        'created_at'            => $data->created_at,
                        'updated_at'            => $data->updated_at,
                ];

            });
            return[
                'id'    => $gateway->id,
                'image' => $gateway->image,
                'slug'  => $gateway->slug,
                'code'  => $gateway->code,
                'type'  => $gateway->type,
                'alias' => $gateway->alias,
                'supported_currencies'  => $gateway->supported_currencies,
                'status'                => $gateway->status,
                'currencies'            => $currencies

            ];
        });
        $get_remaining_fields = [
            'transaction_type'  =>  PaymentGatewayConst::TYPEADDMONEY,
            'attribute'         =>  PaymentGatewayConst::SEND,
        ];
        $data =[
            'base_curr'             => get_default_currency_code(),
            'base_curr_rate'        => getAmount(1,get_wallet_precision()),
            'get_remaining_fields'  => (object) $get_remaining_fields,
            'default_image'         => "backend/images/default/default.webp",
            "image_path"            => "backend/images/payment-gateways",
            'userWallet'            => (object)$userWallet,
            'gateways'              => $gateways,
            'transactions'          => $transactions,
        ];
        $message =  ['success'=>[__('Add Money Information!')]];
        return Helpers::success($data,$message);
    }
    public function submitData(Request $request) {

        if (is_null($request->source)) {
            $request->merge([
                'source' => GlobalConst::APP,
                'success_url'  => null,
                'cancel_url'   => null,
            ]);
        }

        $validator = Validator::make($request->all(), [
           'currency'    => "required",
           'amount'      => "required|numeric|gt:0",
           'source'      => 'nullable|string|in:WEB,APP',
           'success_url' => "nullable|string",
           'cancel_url'  => "nullable|string",
        ]);
        if($validator->fails()){
            $error =  ['error'=>$validator->errors()->all()];
            return Helpers::validation($error);
        }
        $user = auth()->user();
        $alias = $request->currency;
        $amount = $request->amount;
        $payment_gateways_currencies = PaymentGatewayCurrency::where('alias',$alias)->whereHas('gateway', function ($gateway) {
            $gateway->where('slug', PaymentGatewayConst::add_money_slug());
            $gateway->where('status', 1);
             })->first();
        if( !$payment_gateways_currencies){
        $error = ['error'=>[__('Gateway Information is not available. Please provide payment gateway currency alias')]];
        return Helpers::error($error);
        }
        $defualt_currency = Currency::default();

        $user_wallet = UserWallet::auth()->where('currency_id', $defualt_currency->id)->first();

        if(!$user_wallet) {
            $error = ['error'=>[__('User wallet not found')]];
            return Helpers::error($error);
        }
        if($amount < ($payment_gateways_currencies->min_limit/$payment_gateways_currencies->rate) || $amount > ($payment_gateways_currencies->max_limit/$payment_gateways_currencies->rate)) {
            $error = ['error'=>[__('Please follow the transaction limit')]];
            return Helpers::error($error);
        }

        try{
            $instance = PaymentGatewayApi::init($request->all())->type(PaymentGatewayConst::TYPEADDMONEY)->gateway()->api()->get();

            if (isset($instance['response']) && $instance['response'] instanceof JsonResponse){
                $original = $instance['response']->original;
                $error = [
                    'error' => $original['message']['error'] ?? ['Invalid Request'],
                ];
                return Helpers::error($error);
            }

            if( $instance['distribute'] == "tatumInitApi" ){
                $data = [
                    'gateway_info' =>$instance['response'],
                    'payment_info' =>[
                        'request_amount' => get_amount($instance['amount']->requested_amount,$instance['amount']->default_currency,8),
                        'exchange_rate' => "1".' '.$instance['amount']->default_currency.' = '.get_amount($instance['amount']->sender_cur_rate,$instance['amount']->sender_cur_code,8),
                        'total_charge' => get_amount($instance['amount']->total_charge,$instance['amount']->sender_cur_code,8),
                        'will_get' => get_amount($instance['amount']->will_get,$instance['amount']->default_currency,8),
                        'payable_amount' =>  get_amount($instance['amount']->total_amount,$instance['amount']->sender_cur_code,8),
                    ]
                ];
                $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                return Helpers::success($data,$message);

            }
            $trx = $instance['response']['id']??$instance['response']['trx']??$instance['response']['reference_id']?? $instance['response']['order_id']??$instance['response']['tokenValue'] ?? $instance['response']['url'] ?? $instance['response']['temp_identifier']??$instance['response']['identifier']??'';
            $temData = TemporaryData::where('identifier',$trx)->first();
            if(!$temData){
                $error = ['error'=>[__("Invalid Request. Please try again")]];
                return Helpers::error($error);
            }

            $payment_gateway_currency = PaymentGatewayCurrency::where('id', $temData->data->currency)->first();
            $payment_gateway = PaymentGateway::where('id', $temData->data->gateway)->first();
            if($payment_gateway->type == "AUTOMATIC") {
                if($temData->type == PaymentGatewayConst::STRIPE) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$temData->data->response->link."?prefilled_email=".@$user->email,
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }elseif($temData->type == PaymentGatewayConst::PAYSTACK) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$instance['response']['link'],
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }elseif($temData->type == PaymentGatewayConst::COINGATE) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => $instance['response']['link'],
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }else if ($temData->type == PaymentGatewayConst::QRPAY) {
                    $payment_informations = [
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()) . ' ' . $temData->data->amount->default_currency,
                        'exchange_rate' => "1" . ' ' . $temData->data->amount->default_currency . ' = ' . getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()) . ' ' . $temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()) . ' ' . $temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()) . ' ' . $temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()) . ' ' . $temData->data->amount->sender_cur_code,
                    ];
                    $data = [
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$instance['response']['link'],
                        'method' => "get",
                    ];
                    $message =  ['success' => [__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }else if($temData->type == PaymentGatewayConst::PAYPAL) {
                    $payment_informations =[
                    'trx' =>  $temData->identifier,
                    'gateway_currency_name' =>  $payment_gateway_currency->name,
                    'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                    'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate).' '.$temData->data->amount->sender_cur_code,
                    'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                    'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$temData->data->response->links,
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data, $message);

                }elseif($temData->type == PaymentGatewayConst::SSLCOMMERZ) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => $instance['response']['link'],
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }else if($temData->type == PaymentGatewayConst::FLUTTER_WAVE) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$temData->data->response->link,
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }else if($temData->type == PaymentGatewayConst::RAZORPAY){
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type'          => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias'                 => $payment_gateway_currency->alias,
                        'identify'              => $temData->type,
                        'payment_informations'  => $payment_informations,
                        'url'                   => $instance['response']['redirect_url'],
                        'method'                => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);

                }elseif($temData->type == PaymentGatewayConst::PAGADITO) {
                    $payment_informations =[
                        'trx'                   => $temData->identifier,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'request_amount'        => getDynamicAmount($temData->data->amount->requested_amount).' '.$temData->data->amount->default_currency,
                        'exchange_rate'         => "1".' '.$temData->data->amount->default_currency.' = '.getDynamicAmount($temData->data->amount->sender_cur_rate).' '.$temData->data->amount->sender_cur_code,
                        'total_charge'          => getDynamicAmount($temData->data->amount->total_charge).' '.$temData->data->amount->sender_cur_code,
                        'will_get'              => getDynamicAmount($temData->data->amount->will_get).' '.$temData->data->amount->default_currency,
                        'payable_amount'        => getDynamicAmount($temData->data->amount->total_amount).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type'          => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias'                 => $payment_gateway_currency->alias,
                        'identify'              => $temData->type,
                        'payment_informations'  => $payment_informations,
                        'url'                   => $instance['response']['redirect_url'],
                        'method'                => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }else if($temData->type == PaymentGatewayConst::PERFECT_MONEY){
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type'          => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias'                 => $payment_gateway_currency->alias,
                        'identify'              => $temData->type,
                        'payment_informations'  => $payment_informations,
                        'url'                   => $instance['response']['redirect_url'],
                        'method'                => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);

                }elseif($temData->type == PaymentGatewayConst::BKASH) {
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'payment_informations' => $payment_informations,
                        'url' => @$instance['response']['link'],
                        'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }elseif($temData->type == PaymentGatewayConst::AUTHORIZE) {
                    // $payment_informations =[
                    //     'trx' =>  $temData->identifier,
                    //     'gateway_currency_name' =>  $payment_gateway_currency->name,
                    //     'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                    //     'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    //     'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    //     'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                    //     'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    // ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'tempToken' => $temData['identifier'],
                        // 'payment_informations' => $payment_informations,
                        // 'url' => @$instance['response']['link'],
                        // 'method' => "get",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data,$message);
                }

            }elseif($payment_gateway->type == "MANUAL"){
                    $payment_informations =[
                        'trx' =>  $temData->identifier,
                        'gateway_currency_name' =>  $payment_gateway_currency->name,
                        'request_amount' => getAmount($temData->data->amount->requested_amount,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'exchange_rate' => "1".' '.$temData->data->amount->default_currency.' = '.getAmount($temData->data->amount->sender_cur_rate).' '.$temData->data->amount->sender_cur_code,
                        'total_charge' => getAmount($temData->data->amount->total_charge,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                        'will_get' => getAmount($temData->data->amount->will_get,get_wallet_precision()).' '.$temData->data->amount->default_currency,
                        'payable_amount' =>  getAmount($temData->data->amount->total_amount,get_wallet_precision()).' '.$temData->data->amount->sender_cur_code,
                    ];
                    $data =[
                        'gateway_type' => $payment_gateway->type,
                        'gateway_currency_name' => $payment_gateway_currency->name,
                        'alias' => $payment_gateway_currency->alias,
                        'identify' => $temData->type,
                        'details' => $payment_gateway->desc??null,
                        'input_fields' => $payment_gateway->input_fields??null,
                        'payment_informations' => $payment_informations,
                        'url' => route('api.manual.payment.confirmed'),
                        'method' => "post",
                    ];
                    $message =  ['success'=>[__('Add Money Inserted Successfully')]];
                    return Helpers::success($data, $message);
            }else{
                $error = ['error'=>[__('Something went wrong! Please try again')]];
                return Helpers::error($error);
            }

        }catch(Exception $e) {
            $error = ['error'=>[$e->getMessage()??__("Something went wrong! Please try again.")]];
            return Helpers::error($error);
        }
    }
    public function success(Request $request, $gateway)
    {
        $requestData = $request->all();
        $token = $requestData['token'] ?? "";
        $checkTempData = TemporaryData::where("type", $gateway)->where("identifier", $token)->first();
        if (!$checkTempData){
            $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
            return Helpers::error($message);
        }

        $checkTempData = $checkTempData->toArray();
        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $success_url = $checkTempData['data']->success_url ?? '';
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';

        try {
            PaymentGatewayApi::init($checkTempData)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive();
        } catch (Exception $e) {
            return $source ==  GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }


        return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlysuccess(['success' => [__("Payment successful, please go back your app")]]);
    }
    public function cancel(Request $request, $gateway)
    {
        $requestData = $request->all();
        $token = $requestData['token'] ?? "";

        $checkTempData = TemporaryData::where("type",$gateway)->where("identifier",$token)->first();
        $source      = $checkTempData->data->validate_data->source ?? GlobalConst::APP;
        $cancel_url  = $checkTempData->data->validate_data->cancel_return_url ?? '';


        if(!$checkTempData){
            return  $source == GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Transaction Failed. Record didn't save properly. Please try again.")]]);
        }

        if( $token){
            TemporaryData::where("identifier",$token)->delete();
        }

        return $source == GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::onlysuccess(['success' => [__('Payment Canceled Successfully')]]);
    }
    //stripe success
    public function stripePaymentSuccess($trx){
        $token = $trx;
        $checkTempData = TemporaryData::where("type",PaymentGatewayConst::STRIPE)->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];

        if(!$checkTempData) return Helpers::error($message);
        $checkTempData = $checkTempData->toArray();
        $source        = $checkTempData['data']->source ?? GlobalConst::APP;
        $success_url   = $checkTempData['data']->success_url ?? '';
        $cancel_url    = $checkTempData['data']->cancel_url ?? '';

        try{
            PaymentGatewayApi::init($checkTempData)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('stripe');
        }catch(Exception $e) {
            return $source ==  GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }


        return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlysuccess(['success' => [__("Payment successful, please go back your app")]]);

    }
    public function flutterwaveCallback()
    {
        $status = request()->status;

        $transactionID = Flutterwave::getTransactionIDFromCallback();
        $data = Flutterwave::verifyTransaction($transactionID);
        $requestData = request()->tx_ref;
        $token = $requestData;
        $checkTempData = TemporaryData::where("type",'flutterwave')->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
        if(!$checkTempData) return Helpers::error($message);

        $checkTempData = $checkTempData->toArray();
        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $success_url = $checkTempData['data']->success_url ?? '';
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';


        if ($status ==  'successful' || $status == 'completed') {
            try{
                 PaymentGatewayApi::init($checkTempData)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('flutterWave');
            }catch(Exception $e) {
                return $source ==  GlobalConst::WEB
                        ? redirect()->away($cancel_url)
                        : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
            }

            return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlySuccess(['success' => [__("Payment successful, please go back your app'")]]);
        }
        elseif ($status ==  'cancelled'){
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Payment Cancelled,please go back your app")]]);
        }
        else{
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Payment Cancelled,please go back your app")]]);
        }
    }
     //sslcommerz success
    public function sllCommerzSuccess(Request $request){
        $data = $request->all();
        $token = $data['tran_id'];
        $checkTempData = TemporaryData::where("type",PaymentGatewayConst::SSLCOMMERZ)->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
        if(!$checkTempData) return Helpers::error($message);
        $checkTempData = $checkTempData->toArray();
        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $success_url = $checkTempData['data']->success_url ?? '';
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';


        $creator_table = $checkTempData['data']->creator_table ?? null;
        $creator_id = $checkTempData['data']->creator_id ?? null;
        $creator_guard = $checkTempData['data']->creator_guard ?? null;
        $api_authenticated_guards = PaymentGatewayConst::apiAuthenticateGuard();
        if($creator_table != null && $creator_id != null && $creator_guard != null) {
            if(!array_key_exists($creator_guard,$api_authenticated_guards)) throw new Exception(__("Request user doesn\'t save properly. Please try again"));
            $creator = DB::table($creator_table)->where("id",$creator_id)->first();
            if(!$creator) throw new Exception(__("Request user doesn\'t save properly. Please try again"));
            $api_user_login_guard = $api_authenticated_guards[$creator_guard];
            Auth::guard($api_user_login_guard)->loginUsingId($creator->id);
        }
        if( $data['status'] != "VALID"){
            return $source ==  GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }
        try{
            PaymentGatewayApi::init($checkTempData)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('sslcommerz');
        }catch(Exception $e) {
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }

        return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlySuccess(['success' => [__("Payment successful, please go back your app'")]]);
    }
    //sslCommerz fails
    public function sllCommerzFails(Request $request){
        $data = $request->all();

        $token = $data['tran_id'];
        $checkTempData = TemporaryData::where("type",PaymentGatewayConst::SSLCOMMERZ)->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
        if(!$checkTempData) return Helpers::error($message);
        $checkTempData = $checkTempData->toArray();

        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';

        $creator_table = $checkTempData['data']->creator_table ?? null;
        $creator_id = $checkTempData['data']->creator_id ?? null;
        $creator_guard = $checkTempData['data']->creator_guard ?? null;

        $api_authenticated_guards = PaymentGatewayConst::apiAuthenticateGuard();
        if($creator_table != null && $creator_id != null && $creator_guard != null) {
            if(!array_key_exists($creator_guard,$api_authenticated_guards)) throw new Exception(__("Request user doesn\'t save properly. Please try again"));
            $creator = DB::table($creator_table)->where("id",$creator_id)->first();
            if(!$creator) throw new Exception(__("Request user doesn\'t save properly. Please try again"));
            $api_user_login_guard = $api_authenticated_guards[$creator_guard];
            Auth::guard($api_user_login_guard)->loginUsingId($creator->id);
        }
        if( $data['status'] == "FAILED"){
            TemporaryData::destroy($checkTempData['id']);
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Payment Failed,please go back your app")]]);

        }

    }
    //sslCommerz canceled
    public function sllCommerzCancel(Request $request){
        $data = $request->all();
        $token = $data['tran_id'];
        $checkTempData = TemporaryData::where("type",PaymentGatewayConst::SSLCOMMERZ)->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
        if(!$checkTempData) return Helpers::error($message);
        $checkTempData = $checkTempData->toArray();

        $source        = $checkTempData['data']->source ?? GlobalConst::APP;
        $cancel_url    = $checkTempData['data']->cancel_url ?? '';


        $creator_table = $checkTempData['data']->creator_table ?? null;
        $creator_id = $checkTempData['data']->creator_id ?? null;
        $creator_guard = $checkTempData['data']->creator_guard ?? null;

        $api_authenticated_guards = PaymentGatewayConst::apiAuthenticateGuard();
        if($creator_table != null && $creator_id != null && $creator_guard != null) {
            if(!array_key_exists($creator_guard,$api_authenticated_guards)) throw new Exception(__('Request user doesn\'t save properly. Please try again'));
            $creator = DB::table($creator_table)->where("id",$creator_id)->first();
            if(!$creator) throw new Exception(__("Request user doesn\'t save properly. Please try again"));
            $api_user_login_guard = $api_authenticated_guards[$creator_guard];
            Auth::guard($api_user_login_guard)->loginUsingId($creator->id);
        }
        if( $data['status'] != "VALID"){
            TemporaryData::destroy($checkTempData['id']);
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Payment Cancelled,please go back your app")]]);
        }
    }

    // Qrpay Call Back
    public function qrPaySuccess(Request $request)
    {

        if ($request->type ==  'success') {
            $requestData = $request->all();
            $checkTempData = TemporaryData::where("type", 'qrpay')->where("identifier", $requestData['data']['custom'])->first();

            $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
            if(!$checkTempData) return Helpers::error($message);
            $checkTempData = $checkTempData->toArray();

            $source      = $checkTempData['data']->source ?? GlobalConst::APP;
            $success_url = $checkTempData['data']->success_url ?? '';
            $cancel_url  = $checkTempData['data']->cancel_url ?? '';

            try {
                PaymentGatewayApi::init($checkTempData)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('qrpay');
            } catch (Exception $e) {
                return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
            }

            return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlySuccess(['success' => [__("Payment Successful, Please Go Back Your App")]]);

        } else {
            $message = ['error' => ['Payment Failed,please go back your app']];
            return Helpers::error($message);
        }
    }
    // QrPay Cancel
    public function qrPayCancel(Request $request, $trx_id)
    {
        $data = TemporaryData::where("identifier", $trx_id)->delete();
        if(!$data){
            $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
            return Helpers::error($message);
        }
        $message = ['error' => [__('Payment Cancelled,please go back your app')]];
        return Helpers::onlysuccess($message);

        $token = $trx_id;
        $temData =  TemporaryData::where("identifier",$token)->first();
        $message = ['error' => [__('Transaction Failed. Record didn\'t saved properly. Please try again')]];
        if(!$temData) return Helpers::error($message);


        $checkTempData = $temData->toArray();
        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $success_url = $checkTempData['data']->success_url ?? '';
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';
        if( $token){
            $temData->delete();
        }


        return $source == GlobalConst::WEB
            ? redirect()->away($cancel_url)
            : Helpers::onlySuccess(['success' => [__("Payment Canceled, please go back your app")]]);

    }
    public function perfectSuccess(Request $request, $gateway){

        try{
            $token = PaymentGatewayApi::getToken($request->all(),$gateway);
            $temp_data = TemporaryData::where("type",PaymentGatewayConst::PERFECT_MONEY)->where("identifier",$token)->first();

            if(!$temp_data) {
                if(Transaction::where('callback_ref',$token)->exists()) {
                    $message = ['error' => [__("Transaction request sended successfully!")]];
                    return Helpers::onlySuccess($message);
                }else {
                    $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
                    return Helpers::error($message);
                }
            }

            $update_temp_data = json_decode(json_encode($temp_data->data),true);
            $update_temp_data['callback_data']  = $request->all();
            $temp_data->update([
                'data'  => $update_temp_data,
            ]);

            $temp_data = $temp_data->toArray();
            $source      = $temp_data['data']->source ?? GlobalConst::APP;
            $success_url = $temp_data['data']->success_url ?? '';
            $cancel_url  = $temp_data['data']->cancel_url ?? '';

            $instance = PaymentGatewayApi::init($temp_data)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('perfect-money');
        }catch(Exception $e) {
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }

        return $source == GlobalConst::WEB
            ? redirect()->away($success_url)
            : Helpers::onlySuccess(['success' => [__("Payment Successful, Please Go Back Your App")]]);
    }

    public function perfectCancel(Request $request,$gateway) {
        $token = PaymentGatewayApi::getToken($request->all(),$gateway);
        $temp_data = TemporaryData::where("type",PaymentGatewayConst::TYPEADDMONEY)->where("identifier",$token)->first();
        $message = ['error' => [__('Transaction Failed. Record didn\'t saved properly. Please try again')]];
        if(!$temp_data) return Helpers::error($message);

        $checkTempData = $temp_data->toArray();
        $source      = $checkTempData['data']->source ?? GlobalConst::APP;
        $cancel_url  = $checkTempData['data']->cancel_url ?? '';
        if( $token){
            $temp_data->delete();
        }

        return $source == GlobalConst::WEB
            ? redirect()->away($cancel_url)
            : Helpers::onlySuccess(['success' => [__("Payment Canceled Successfully")]]);

    }
     //coingate
     public function coinGateSuccess(Request $request, $gateway){
        try{
            $token = $request->token;
            $checkTempData = TemporaryData::where("type",PaymentGatewayConst::COINGATE)->where("identifier",$token)->first();
            if(!$checkTempData){
                $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
                return Helpers::error($message);
            }
            if(Transaction::where('callback_ref', $token)->exists()) {
                if(!$checkTempData){
                    $message = ['error' => [__("Transaction request sended successfully!")]];
                    return Helpers::error($message);
                }
            }else {
                if(!$checkTempData){
                    $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
                    return Helpers::error($message);
                }
            }
            $update_temp_data = json_decode(json_encode($checkTempData->data),true);
            $update_temp_data['callback_data']  = $request->all();
            $checkTempData->update([
                'data'  => $update_temp_data,
            ]);
            $temp_data = $checkTempData->toArray();
            $source      = $temp_data['data']->source ?? GlobalConst::APP;
            $success_url = $temp_data['data']->success_url ?? '';
            $cancel_url  = $temp_data['data']->cancel_url ?? '';

            PaymentGatewayApi::init($temp_data)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive('coingate');
        }catch(Exception $e) {
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }

         return $source == GlobalConst::WEB
                ? redirect()->away($success_url)
                : Helpers::onlySuccess(['success' => [__("Payment Successful, Please Go Back Your App")]]);
    }
    public function coinGateCancel(Request $request, $gateway){
        if($request->has('token')) {
            $identifier = $request->token;
            $temData =  TemporaryData::where("identifier",$identifier)->first();
            $message = ['error' => [__('Transaction Failed. Record didn\'t saved properly. Please try again')]];
            if(!$temData) return Helpers::error($message);

            $checkTempData = $temData->toArray();
            $source      = $checkTempData['data']->source ?? GlobalConst::APP;
            $success_url = $checkTempData['data']->success_url ?? '';
            $cancel_url  = $checkTempData['data']->cancel_url ?? '';
            if( $identifier){
                $temData->delete();
            }


            return $source == GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::onlySuccess(['success' => [__("Add Money Canceled Successfully , Please Go Back Your App")]]);
        }
        $message = ['success' => [__("Add Money Canceled Successfully , Please Go Back Your App")]];
        return Helpers::onlySuccess($message);
    }
    public function cryptoPaymentConfirm(Request $request, $trx_id)
    {
        $transaction = Transaction::where('trx_id',$trx_id)->where('status', PaymentGatewayConst::STATUSWAITING)->first();
        if(!$transaction){
            $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
            return Helpers::error($message);
        }
        $user =  $transaction->user;
        $gateway_currency =  $transaction->currency->alias;
        $request_data = $request->merge([
            'currency' => $gateway_currency,
            'amount' => $transaction->request_amount,
        ]);
        $output = PaymentGatewayHelper::init($request_data->all())->type(PaymentGatewayConst::TYPEADDMONEY)->gateway()->get();


        $dy_input_fields = $transaction->details->payment_info->requirements ?? [];
        $validation_rules = $this->generateValidationRules($dy_input_fields);


        $validator = [];
        if(count($validation_rules) > 0) {
            $validator = Validator::make($request->all(), $validation_rules);
            if($validator->fails()){
                $error =  ['error'=>$validator->errors()->all()];
                return Helpers::validation($error);
            }
            $validated =  $validator->validate();
        }

        if(!isset($validated['txn_hash'])){
            $message = ['error' => [__('Transaction hash is required for verify')]];
            return Helpers::error($message);
        }

        $receiver_address = $transaction->details->payment_info->receiver_address ?? "";

        // check hash is valid or not
        $crypto_transaction = CryptoTransaction::where('txn_hash', $validated['txn_hash'])
                                                ->where('receiver_address', $receiver_address)
                                                ->where('asset',$transaction->gateway_currency->currency_code)
                                                ->where(function($query) {
                                                    return $query->where('transaction_type',"Native")
                                                                ->orWhere('transaction_type', "native");
                                                })
                                                ->where('status',PaymentGatewayConst::NOT_USED)
                                                ->first();

        if(!$crypto_transaction){
            $message = ['error' => [__('Transaction hash is not valid! Please input a valid hash')]];
            return Helpers::error($message);
        }

        if($crypto_transaction->amount >= $transaction->total_payable == false) {
            if(!$crypto_transaction){
                $message = ['error' => [__("Insufficient amount added. Please contact with system administrator")]];
                return Helpers::error($message);
            }
        }

        DB::beginTransaction();
        try{

            // Update user wallet balance
            DB::table($transaction->creator_wallet->getTable())
                ->where('id',$transaction->creator_wallet->id)
                ->increment('balance',$transaction->request_amount);

            // update crypto transaction as used
            DB::table($crypto_transaction->getTable())->where('id', $crypto_transaction->id)->update([
                'status'        => PaymentGatewayConst::USED,
            ]);

            // update transaction status
            $transaction_details = json_decode(json_encode($transaction->details), true);
            $transaction_details['payment_info']['txn_hash'] = $validated['txn_hash'];

            DB::table($transaction->getTable())->where('id', $transaction->id)->update([
                'details'       => json_encode($transaction_details),
                'status'        => PaymentGatewayConst::STATUSSUCCESS,
                'available_balance'        => $transaction->available_balance + $transaction->request_amount,
            ]);
            //notification
            $notification_content = [
                'title'         => "Add Money",
                'message'       => "Your Wallet"." (".$output['wallet']->currency->code.")  "."balance  has been added"." ".$output['amount']->requested_amount.' '. $output['wallet']->currency->code,
                'time'          => Carbon::now()->diffForHumans(),
                'image'         => get_image($user->image,'user-profile'),
            ];

            UserNotification::create([
                'type'      => NotificationConst::BALANCE_ADDED,
                'user_id'  =>  $user->id,
                'message'   => $notification_content,
            ]);

            DB::commit();

        }catch(Exception $e) {
            DB::rollback();
            $message = ['error' => [__('Something went wrong! Please try again')]];
            return Helpers::error($message);
        }

        $message = ['success' => [__('Payment Confirmation Success')]];
        return Helpers::onlysuccess($message);
    }
    public function redirectBtnPay(Request $request, $gateway)
    {
        try{
            return PaymentGatewayApi::init([])->handleBtnPay($gateway, $request->all());
        }catch(Exception $e) {
            $message = ['error' => [$e->getMessage()]];
            return Helpers::error($message);
        }
    }
    public function successGlobal(Request $request, $gateway){
        try{
            $token = PaymentGatewayApi::getToken($request->all(),$gateway);
            $temp_data = TemporaryData::where("identifier",$token)->first();

            if(!$temp_data) {
                if(Transaction::where('callback_ref',$token)->exists()) {
                    $message = ['error' => [__('Transaction request sended successfully!')]];
                    return Helpers::error($message);
                }else {
                    $message = ['error' => [__('Transaction failed. Record didn\'t saved properly. Please try again')]];
                    return Helpers::error($message);
                }
            }

            $update_temp_data = json_decode(json_encode($temp_data->data),true);
            $update_temp_data['callback_data']  = $request->all();
            $temp_data->update([
                'data'  => $update_temp_data,
            ]);
            $temp_data = $temp_data->toArray();
            $source      = $temp_data['data']->source ?? GlobalConst::APP;
            $success_url = $temp_data['data']->success_url ?? '';
            $cancel_url  = $temp_data['data']->cancel_url ?? '';

            $instance = PaymentGatewayApi::init($temp_data)->type(PaymentGatewayConst::TYPEADDMONEY)->responseReceive($temp_data['type']);

            // return $instance;
        }catch(Exception $e) {
            return $source ==  GlobalConst::WEB
                    ? redirect()->away($cancel_url)
                    : Helpers::error(['error' => [__("Something went wrong! Please try again.")]]);
        }

        return $source == GlobalConst::WEB
            ? redirect()->away($success_url)
            : Helpers::onlySuccess(['success' => [__("Payment Successful, Please Go Back Your App")]]);
    }
    public function cancelGlobal(Request $request,$gateway) {
        $token = PaymentGatewayApi::getToken($request->all(),$gateway);
        $temp_data = TemporaryData::where("identifier",$token)->first();
        $message = ['error' => [__('Transaction Failed. Record didn\'t saved properly. Please try again')]];
        if(!$temp_data) return Helpers::error($message);

        $checkTempData = $temp_data->toArray();
        $source        = $checkTempData['data']->source ?? GlobalConst::APP;
        $cancel_url    = $checkTempData['data']->cancel_url ?? '';

        try{
            if($temp_data != null) {
                $temp_data->delete();
            }
        }catch(Exception $e) {
            // Handel error
        }
        return $source == GlobalConst::WEB
                ? redirect()->away($cancel_url)
                : Helpers::onlySuccess(['success' => [__("Add Money Canceled Successfully , Please Go Back Your App")]]);
    }
    public function postSuccess(Request $request, $gateway)
    {
        try{
            $token = PaymentGatewayApi::getToken($request->all(),$gateway);
            $temp_data = TemporaryData::where("identifier",$token)->first();
            if($temp_data && $temp_data->data->creator_guard != 'api') {
                Auth::guard($temp_data->data->creator_guard)->loginUsingId($temp_data->data->creator_id);
            }
        }catch(Exception $e) {
            $message = ['error' => [$e->getMessage()]];
            return Helpers::error($message);
        }

        return $this->successGlobal($request, $gateway);
    }
    public function postCancel(Request $request, $gateway)
    {
        try{
            $token = PaymentGatewayApi::getToken($request->all(),$gateway);
            $temp_data = TemporaryData::where("identifier",$token)->first();
            if($temp_data && $temp_data->data->creator_guard != 'api') {
                Auth::guard($temp_data->data->creator_guard)->loginUsingId($temp_data->data->creator_id);
            }
        }catch(Exception $e) {
            $message = ['error' => [$e->getMessage()]];
            return Helpers::error($message);
        }

        return $this->cancelGlobal($request, $gateway);
    }


     /**
     * Method function authorize payment submit
     * @param Illuminate\Http\Request $request
     */
    public function authorizePaymentSubmit(Request $request){
        $validator          = Validator::make($request->all(),[
            'identifier'    => 'required',
            'card_number'   => 'required',
            'date'          => 'required',
            'code'          => 'required'
        ]);

        if($validator->fails()){
            $message = ['error' => [$validator->errors()->all()]];
            return Helpers::error($message);
        }
        $validated          = $validator->validate();

        $temp_data          = TemporaryData::where('identifier',$validated['identifier'])->first();
        if(!$temp_data){
            $message = ['error' => [__('Sorry ! Data not found.')]];
            return Helpers::error($message);
        }

        $request->merge([
            'token' => $validated['identifier']
        ]);

        $request_data = $request->all();


        $gateway_credentials          = $this->authorizeCredentials($temp_data);
        $basic_settings               = BasicSettings::first();

        $validated['card_number']     = str_replace(' ', '', $validated['card_number']);

        $convert_date   = explode('/', $validated['date']);
        $month          = $convert_date[1];
        $year           = $convert_date[0];

        $current_year   = substr(date('Y'), 0, 2);
        $full_year      = $current_year . $year;

        $validated['date'] = $full_year . '-' . $month;
        $merchantAuthentication = new AnetAPI\MerchantAuthenticationType();
        $merchantAuthentication->setName($gateway_credentials->app_login_id);
        $merchantAuthentication->setTransactionKey($gateway_credentials->transaction_key);
        $amount = $temp_data->data->amount->total_amount;


        // Set the transaction's refId
        $refId = 'ref' . time();

        // Create the payment data for a credit card
        $creditCard = new AnetAPI\CreditCardType();
        $creditCard->setCardNumber($validated['card_number']);
        $creditCard->setExpirationDate($validated['date']);
        $creditCard->setCardCode($validated['code']);


        // Add the payment data to a paymentType object
        $paymentOne = new AnetAPI\PaymentType();
        $paymentOne->setCreditCard($creditCard);

        $generate_invoice_number        = generate_random_string_number(10) . time();

        // Create order information
        $order = new AnetAPI\OrderType();
        $order->setInvoiceNumber($generate_invoice_number);
        $order->setDescription("Add Money");

        // Set the customer's Bill To address
        $customerAddress = new AnetAPI\CustomerAddressType();
        $customerAddress->setFirstName(auth()->user()->firstname);
        $customerAddress->setLastName(auth()->user()->lastname);
        $customerAddress->setCompany($basic_settings->site_name);
        $customerAddress->setAddress(auth()->user()->address->address ?? '');
        $customerAddress->setCity(auth()->user()->address->city ?? '');
        $customerAddress->setState(auth()->user()->address->state ?? '');
        $customerAddress->setZip(auth()->user()->address->zip ?? '');
        $customerAddress->setCountry(auth()->user()->address->country ?? '');

        $make_customer_id       = auth()->user()->id . $gateway_credentials->code;
        // Set the customer's identifying information
        $customerData = new AnetAPI\CustomerDataType();
        $customerData->setType("individual");
        $customerData->setId($make_customer_id);
        $customerData->setEmail(auth()->user()->email);

        // Add values for transaction settings
        $duplicateWindowSetting = new AnetAPI\SettingType();
        $duplicateWindowSetting->setSettingName("duplicateWindow");
        $duplicateWindowSetting->setSettingValue("60");

        // Create a TransactionRequestType object and add the previous objects to it
        $transactionRequestType = new AnetAPI\TransactionRequestType();
        $transactionRequestType->setTransactionType("authCaptureTransaction");
        $transactionRequestType->setAmount($amount);
        $transactionRequestType->setOrder($order);
        $transactionRequestType->setPayment($paymentOne);
        $transactionRequestType->setBillTo($customerAddress);
        $transactionRequestType->setCustomer($customerData);
        $transactionRequestType->addToTransactionSettings($duplicateWindowSetting);

        // Assemble the complete transaction request
        $request = new AnetAPI\CreateTransactionRequest();
        $request->setMerchantAuthentication($merchantAuthentication);
        $request->setRefId($refId);
        $request->setTransactionRequest($transactionRequestType);


        // Create the controller and get the response
        $controller = new AnetController\CreateTransactionController($request);

        if($gateway_credentials->mode == GlobalConst::ENV_SANDBOX){
            $environment = \net\authorize\api\constants\ANetEnvironment::SANDBOX;
        }else{
            $environment = \net\authorize\api\constants\ANetEnvironment::PRODUCTION;
        }
        $response   = $controller->executeWithApiResponse($environment);
        if ($response != null) {
            if ($response->getMessages()->getResultCode() == "Ok") {
                $tresponse = $response->getTransactionResponse();

                if ($tresponse != null && $tresponse->getMessages() != null) {

                    $request_data = new Request($request_data);
                    return $this->successGlobal($request_data, PaymentGatewayConst::AUTHORIZE);
                }else {
                    $message = ['error' => [__('Transaction failed')]];
                    return Helpers::error($message);
                    if ($tresponse->getErrors() != null) {
                        $message = ['error' => [__($tresponse->getErrors()[0]->getErrorText())]];
                        return Helpers::error($message);
                    }
                }
            }else {
                $message = ['error' => [__('Transaction failed')]];
                return Helpers::error($message);

                $tresponse = $response->getTransactionResponse();

                if ($tresponse != null && $tresponse->getErrors() != null) {
                    $message = ['error' => [__($tresponse->getErrors()[0]->getErrorText())]];
                    return Helpers::error($message);
                } else {
                    $message = ['error' => [__($response->getMessages()->getMessage()[0]->getText())]];
                    return Helpers::error($message);
                }
            }
        }else {
            $message = ['error' => [__('No response returned')]];
            return Helpers::error($message);

        }
    }

}
