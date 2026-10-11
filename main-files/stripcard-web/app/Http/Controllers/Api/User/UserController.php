<?php

namespace App\Http\Controllers\Api\User;

use App\Constants\PaymentGatewayConst;
use App\Http\Controllers\Controller;
use App\Http\Helpers\Api\Helpers;
use App\Http\Helpers\TransactionLimit;
use App\Http\Resources\User\AddMoneyLogs;
use App\Http\Resources\User\AddSubBalanceLogs;
use App\Http\Resources\User\GiftCardLogs;
use App\Http\Resources\User\TransferMoneyLogs;
use App\Http\Resources\User\VirtualCardLogs;
use App\Http\Resources\User\WithdrawMoneyLog;
use App\Models\Admin\PaymentGatewayCurrency;
use App\Models\Admin\TransactionSetting;
use App\Models\Transaction;
use App\Models\UserNotification;
use App\Models\UserWallet;
use App\Models\VirtualCardApi;
use App\Providers\Admin\BasicSettingsProvider;
use App\Traits\AdminNotifications\AuthNotifications;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rules\Password;


class UserController extends Controller
{
    use AuthNotifications;
    protected $api;
    public function __construct()
    {
        $cardApi = VirtualCardApi::first();
        $this->api =  $cardApi;
    }
    public function home()
    {

        $user = auth()->user();
        $totalAddMoney = Transaction::auth()->addMoney()->where('status', 1)->sum('request_amount');
        $totalTransactions = Transaction::auth()
            ->whereIn('id', function ($query) {
                $query->selectRaw('MIN(id)')
                    ->from('transactions')
                    ->groupBy('trx_id');
            })
            ->where('status', 1)
            ->sum('request_amount');

        $virtualCards = activeCardData()['active_cards'];
        $userWallet = user_wallets(authGuardApi(), 'user_id');
        $transactions = Transaction::auth()->latest()->take(5)->get()->map(function ($item) {
            if ($item->type == payment_gateway_const()::TYPEADDMONEY) {
                return [
                    'id' => $item->id,
                    'type' => $item->attribute,
                    'trx' => $item->trx_id,
                    'transaction_type' => $item->type,
                    'request_amount' => getAmount($item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'payable' => getAmount($item->payable, get_wallet_precision()) . ' ' . $item->currency->currency_code,
                    'status' => $item->stringStatus->value,
                    'remark' => $item->remark ?? "",
                    'date_time' => $item->created_at,

                ];
            } elseif ($item->type == payment_gateway_const()::TYPETRANSFERMONEY) {
                if ($item->attribute == payment_gateway_const()::SEND) {
                    return [
                        'id' => @$item->id,
                        'type' => $item->attribute,
                        'trx' => @$item->trx_id,
                        'transaction_type' => $item->type,
                        'request_amount' => getAmount(@$item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                        'payable' => getAmount(@$item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                        'remark' => $item->remark ?? "",
                        'status' => @$item->stringStatus->value,
                        'date_time' => @$item->created_at,
                    ];
                } elseif ($item->attribute == payment_gateway_const()::RECEIVED) {
                    return [
                        'id' => @$item->id,
                        'type' => $item->attribute,
                        'trx' => @$item->trx_id,
                        'transaction_type' => $item->type,
                        'status' => @$item->stringStatus->value,
                        'request_amount' => getAmount(@$item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                        'payable' => getAmount(@$item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                        'remark' => $item->remark ?? "",
                        'date_time' => @$item->created_at,
                    ];
                }
            } elseif ($item->type == payment_gateway_const()::VIRTUALCARD) {
                $card_currency = $item->details->card_info->currency ?? get_default_currency_code();
                return [
                    'id' => $item->id,
                    'type' => $item->attribute,
                    'trx' => $item->trx_id,
                    'transaction_type' => "Virtual Card" . '(' . @$item->remark . ')',
                    'request_amount' => getAmount($item->request_amount, get_wallet_precision()) . ' ' . $card_currency,
                    'payable' => getAmount($item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'status' => $item->stringStatus->value,
                    'remark' => $item->remark ?? "",
                    'date_time' => $item->created_at,

                ];
            } elseif ($item->type == payment_gateway_const()::TYPEADDSUBTRACTBALANCE) {
                return [
                    'id' => $item->id,
                    'type' => $item->attribute,
                    'trx' => $item->trx_id,
                    'transaction_type' => $item->type,
                    'request_amount' => getAmount($item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'payable' => getAmount(@$item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'remark' => $item->remark ?? "",
                    'status' => $item->stringStatus->value,
                    'date_time' => $item->created_at,

                ];
            } elseif ($item->type == payment_gateway_const()::WITHDRAWMONEY) {
                return [
                    'id' => $item->id,
                    'type' => $item->attribute,
                    'trx' => $item->trx_id,
                    'transaction_type' => $item->type,
                    'request_amount' => getAmount($item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'payable' => getAmount(@$item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'remark' => $item->remark ?? "",
                    'status' => $item->stringStatus->value,
                    'date_time' => $item->created_at,

                ];
            } elseif ($item->type == payment_gateway_const()::GIFTCARD) {
                return [
                    'id' => $item->id,
                    'type' => $item->attribute,
                    'trx' => $item->trx_id,
                    'transaction_type' => $item->type,
                    'request_amount' => getAmount($item->request_amount, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'payable' => getAmount(@$item->payable, get_wallet_precision()) . ' ' . get_default_currency_code(),
                    'remark' => $item->remark ?? "",
                    'status' => $item->stringStatus->value,
                    'date_time' => $item->created_at,

                ];
            }
        });
        $cardCreateCharge = TransactionSetting::where('slug', 'virtual_card')->where('status', 1)->get()->map(function ($data) {
            return [
                'id'                => $data->id,
                'slug'              => $data->slug,
                'title'             => $data->title,
                'fixed_charge'      => getAmount($data->fixed_charge, get_wallet_precision()),
                'percent_charge'    => getAmount($data->percent_charge, get_wallet_precision()),
                'min_limit'         => getAmount($data->min_limit, get_wallet_precision()),
                'max_limit'         => getAmount($data->max_limit, get_wallet_precision()),
                'daily_limit'       => getAmount($data->daily_limit, get_wallet_precision()),
                'monthly_limit'     => getAmount($data->monthly_limit, get_wallet_precision()),
            ];
        })->first();
        $cardReloadCharge = TransactionSetting::where('slug', 'reload_card')->where('status', 1)->get()->map(function ($data) {
            return [
                'id'                => $data->id,
                'slug'              => $data->slug,
                'title'             => $data->title,
                'fixed_charge'      => getAmount($data->fixed_charge, get_wallet_precision()),
                'percent_charge'    => getAmount($data->percent_charge, get_wallet_precision()),
                'min_limit'         => getAmount($data->min_limit, get_wallet_precision()),
                'max_limit'         => getAmount($data->max_limit, get_wallet_precision()),
                'daily_limit'       => getAmount($data->daily_limit, get_wallet_precision()),
                'monthly_limit'     => getAmount($data->monthly_limit, get_wallet_precision()),
            ];
        })->first();
        $cardWithdrawCharge = TransactionSetting::where('slug', 'withdraw_card')->where('status', 1)->get()->map(function ($data) {
            return [
                'id'                => $data->id,
                'slug'              => $data->slug,
                'title'             => $data->title,
                'fixed_charge'      => getAmount($data->fixed_charge, get_wallet_precision()),
                'percent_charge'    => getAmount($data->percent_charge, get_wallet_precision()),
                'min_limit'         => getAmount($data->min_limit, get_wallet_precision()),
                'max_limit'         => getAmount($data->max_limit, get_wallet_precision()),
                'daily_limit'       => getAmount($data->daily_limit, get_wallet_precision()),
                'monthly_limit'     => getAmount($data->monthly_limit, get_wallet_precision()),
            ];
        })->first();

        $cardyfie_card_charge = [
            'universal_card_issues_fee'  => floatval($this->api->config->cardyfie_universal_card_issues_fee ?? 0),
            'platinum_card_issues_fee'   => floatval($this->api->config->cardyfie_platinum_card_issues_fee ?? 0),
            'card_deposit_fixed_fee'     => floatval($this->api->config->cardyfie_card_deposit_fixed_fee ?? 0),
            'card_withdraw_fixed_fee'    => floatval($this->api->config->cardyfie_card_withdraw_fixed_fee ?? 0),
            'card_maintenance_fixed_fee' => floatval($this->api->config->cardyfie_card_maintenance_fixed_fee ?? 0),
            'min_limit'                  => floatval($this->api->config->cardyfie_min_limit ?? 0),
            'max_limit'                  => floatval($this->api->config->cardyfie_max_limit ?? 0),
            'daily_limit'                => floatval($this->api->config->cardyfie_daily_limit ?? 0),
            'monthly_limit'              => floatval($this->api->config->cardyfie_monthly_limit ?? 0),

        ];


        //module access permissions
        $module_access = [
            'add_money'         => module_access_api('add-money'),
            'transfer_money'    => module_access_api('transfer-money'),
            'withdraw_money'    => module_access_api('withdraw-money'),
            'virtual_card'      => module_access_api('virtual-card'),
            'gift_cards'        => module_access_api('gift-cards')
        ];
        $basic_settings = BasicSettingsProvider::get();
        if (!$basic_settings) {
            $message = ['error' => [__("Basic setting not found!")]];
            return Helpers::error($message);
        }
        $notification_config = $basic_settings->push_notification_config;

        if (!$notification_config) {
            $message = ['error' => [__("Notification configuration not found!")]];
            return Helpers::error($message);
        }

        $pusher_credentials = [
            "instanceId" => $notification_config->instance_id ?? '',
            "secretKey" => $notification_config->primary_key ?? '',
        ];

        $data = [
            'base_url'              => get_asset_url(),
            'default_image'         => files_asset_path_basename("profile-default"),
            'image_path'            => files_asset_path_basename("user-profile"),
            'pusher_credentials'    => (object)$pusher_credentials,
            'module_access'         => (object)$module_access,
            'user'                  => $user,
            'base_curr'             => get_default_currency_code(),
            'userWallet'            => (object)$userWallet,
            'active_virtual_system' => activeCardSystem(),
            'card_create_charge'    => $cardCreateCharge,
            'card_reload_charge'    => $cardReloadCharge,
            'card_withdraw_charge'  => $cardWithdrawCharge,
            'cardyfie_card_charge'  => $cardyfie_card_charge,
            'totalAddMoney'         => getAmount($totalAddMoney, get_wallet_precision()) . ' ' . get_default_currency_code(),
            'totalTransactions'     => getAmount($totalTransactions, get_wallet_precision()) . ' ' . get_default_currency_code(),
            'active_cards'          => $virtualCards,
            'transactions'          => $transactions,
        ];
        $message =  ['success' => [__('User Dashboard')]];
        return Helpers::success($data, $message);
    }
    public function profile()
    {
        $user = auth()->user();
        $data = [
            'base_url'      => get_asset_url(),
            'default_image' => files_asset_path_basename("profile-default"),
            'image_path'    => files_asset_path_basename("user-profile"),
            'user'          => $user,
            'countries'     => get_all_countries()
        ];
        $message =  ['success' => [__("User Profile")]];
        return Helpers::success($data, $message);
    }
    public function profileUpdate(Request $request)
    {
        $user = auth()->user();
        $validator = Validator::make($request->all(), [
            'firstname'     => "required|string|max:60",
            'lastname'      => "required|string|max:60",
            'country'       => "nullable|string|max:50",
            'phone_code'    => "nullable|string|max:6",
            'phone'         => "nullable|string|max:11|unique:users,mobile," . $user->id,
            'state'         => "nullable|string|max:50",
            'city'          => "nullable|string|max:50",
            'zip_code'      => "nullable|numeric",
            'address'       => "nullable|string|max:250",
            'image'         => "nullable|image|mimes:jpg,png,svg,webp|max:10240",
        ]);
        if ($validator->fails()) {
            $error =  ['error' => $validator->errors()->all()];
            return Helpers::validation($error);
        }
        $data       = $request->all();
        $mobileCode               = isset($data['phone_code']) ? remove_speacial_char($data['phone_code']) : null;
        $mobile                   = isset($data['phone']) ? remove_speacial_char($data['phone']) : null;
        $validated['firstname']   = $data['firstname'];
        $validated['lastname']    = $data['lastname'];
        $validated['mobile']      = $mobile;
        $validated['mobile_code'] = $mobileCode;
        $complete_phone           = $mobileCode . $mobile;
        $validated['full_mobile'] = isset($data['phone']) ? $complete_phone : null;

        $validated['address']       = [
            'country' => $data['country'] ?? "",
            'state'   => $data['state'] ?? "",
            'city'    => $data['city'] ?? "",
            'zip'     => $data['zip_code'] ?? "",
            'address' => $data['address'] ?? "",
        ];
        if ($request->hasFile("image")) {
            if ($user->image == 'default.png') {
                $oldImage = null;
            } else {
                $oldImage = $user->image;
            }
            $image = upload_file($data['image'], 'user-profile', $oldImage);
            $upload_image = upload_files_from_path_dynamic([$image['dev_path']], 'user-profile');
            delete_file($image['dev_path']);
            $validated['image']     = $upload_image;
        }

        try {
            $user->update($validated);
        } catch (Exception $e) {
            $error = ['error' => [__("Something Went Wrong! Please Try Again")]];
            return Helpers::error($error);
        }
        $message =  ['success' => [__("Profile successfully updated!")]];
        return Helpers::onlysuccess($message);
    }
    public function passwordUpdate(Request $request)
    {

        $basic_settings = BasicSettingsProvider::get();
        $passowrd_rule = "required|string|min:6|confirmed";
        if ($basic_settings->secure_password) {
            $passowrd_rule = ["required", Password::min(8)->letters()->mixedCase()->numbers()->symbols()->uncompromised(), "confirmed"];
        }
        $validator = Validator::make($request->all(), [
            'current_password'      => "required|string",
            'password'              => $passowrd_rule,
        ]);
        if ($validator->fails()) {
            $error =  ['error' => $validator->errors()->all()];
            return Helpers::validation($error);
        }
        if (!Hash::check($request->current_password, auth()->user()->password)) {
            $error = ['error' => [__('Current password didn\'t match')]];
            return Helpers::error($error);
        }

        try {
            auth()->user()->update([
                'password'  => Hash::make($request->password),
            ]);
        } catch (Exception $e) {
            $error = ['error' => [__("Something Went Wrong! Please Try Again")]];
            return Helpers::error($error);
        }
        $message =  ['success' => [__("Password successfully updated!")]];
        return Helpers::onlysuccess($message);
    }
    public function deleteAccount(Request $request)
    {
        $user = auth()->user();
        $user->status = false;
        $user->email_verified = false;
        $user->sms_verified = false;
        $user->kyc_verified = false;
        $user->deleted_at = now();
        $user->save();
        try {
            //admin notification
            $this->deleteUserNotificationToAdmin($user, "USER", 'api');
            $user->token()->revoke();
            $message =  ['success' => [__('User deleted successfully')]];
            return Helpers::onlysuccess($message);
        } catch (Exception $e) {
            $error = ['error' => [__("Something Went Wrong! Please Try Again")]];
            return Helpers::error($error);
        }
    }
    public function transactions()
    {
        // start transaction now
        $addMoney           = Transaction::auth()->addMoney()->orderByDesc("id")->latest()->get();
        $transferMoney      = Transaction::auth()->transferMoney()->orderByDesc("id")->get();
        $virtualCard        = Transaction::auth()->virtualCard()->orderByDesc("id")->get();
        $addSubBalance      = Transaction::auth()->addSubBalance()->orderByDesc("id")->get();
        $withdrawMoney      = Transaction::auth()->withdrawMoney()->orderByDesc("id")->get();
        $giftCards          = Transaction::auth()->giftCards()->orderByDesc("id")->get();


        $transactions = [
            'add_money'         => AddMoneyLogs::collection($addMoney),
            'send_money'        => TransferMoneyLogs::collection($transferMoney),
            'virtual_card'      => VirtualCardLogs::collection($virtualCard),
            'add_sub_balance'   => AddSubBalanceLogs::collection($addSubBalance),
            'withdraw_money'    => WithdrawMoneyLog::collection($withdrawMoney),
            'gift_cards'        => GiftCardLogs::collection($giftCards),
        ];
        $transactions = (object)$transactions;

        $transaction_types = [
            'add_money'         => PaymentGatewayConst::TYPEADDMONEY,
            'transfer_money'    => PaymentGatewayConst::TYPETRANSFERMONEY,
            'virtual_card'      => PaymentGatewayConst::VIRTUALCARD,
            'add_sub_balance'   => PaymentGatewayConst::TYPEADDSUBTRACTBALANCE,
            'withdraw_money'    => PaymentGatewayConst::WITHDRAWMONEY,
            'gift_cards'        => PaymentGatewayConst::GIFTCARD,

        ];
        $transaction_types = (object)$transaction_types;
        $data = [
            'transaction_types' => $transaction_types,
            'transactions' => $transactions,
        ];
        $message =  ['success' => [__("All Transactions")]];
        return Helpers::success($data, $message);
    }
    public function getRemainingBalance()
    {
        $validator = Validator::make(request()->all(), [
            'transaction_type'      => "required|string",
            'attribute'             => "required|string",
            'sender_amount'         => "sometimes|required",
            'currency_code'         => "required|string|exists:currencies,code",
            'charge_id'             => "required|integer",
            'extra_rate'            => "nullable|numeric",
        ]);
        if ($validator->fails()) {
            $error =  ['error' => $validator->errors()->all()];
            return Helpers::validation($error);
        }
        $validated          = $validator->validate();
        $extra_rate         = $validated['extra_rate'] ?? 1;
        $sender_wallet = UserWallet::auth()->active()->whereHas("currency", function ($q) use ($validated) {
            $q->where("code", $validated['currency_code'])->active();
        })->active()->first();
        if (!$sender_wallet) {
            $error = ['error' => [__('User wallet not found')]];
            return Helpers::error($error);
        }

        if ($validated['transaction_type'] == PaymentGatewayConst::WITHDRAWMONEY || $validated['transaction_type'] == PaymentGatewayConst::TYPEADDMONEY) {
            $limits = PaymentGatewayCurrency::where('id', $validated['charge_id'])->first();
        } else {
            if ($validated['transaction_type']  == payment_gateway_const()::VIRTUALCARD && activeCardSystem() == 'cardyfie') {
                $cardApi = VirtualCardApi::first();
                $limits = (object)[
                    'id'            => 1,
                    'daily_limit'   => floatval($cardApi->config->cardyfie_daily_limit ?? 0),
                    'monthly_limit' => floatval($cardApi->config->cardyfie_monthly_limit ?? 0),
                ];
            } else {
                $limits = TransactionSetting::where('id', $validated['charge_id'])->first();
            }
        }

        if (!$limits) {
            $error = ['error' => [__('Charge Data Not Found')]];
            return Helpers::error($error);
        }

        try {
            $result = (new TransactionLimit())->trxLimit('user_id', $sender_wallet->user->id, $validated['transaction_type'], $sender_wallet->currency, $validated['sender_amount'], $limits, $validated['attribute'], 'json', $extra_rate);

            $data = [
                'status'            =>  $result['status'],
                'transaction_type'  =>  $result['transaction_type'],
                'remainingDaily'    =>  $result['data']['remainingDailyTxnSelected'],
                'remainingMonthly'  =>  $result['data']['remainingMonthlyTxnSelected'],
                'currency'          =>  $sender_wallet->currency->code ?? get_default_currency_code(),
            ];

            if ($data['status'] == true) {
                $message =  ['success' => [__($result['message']) ?? ""]];
                return Helpers::success($data, $message);
            } else {
                $error = ['error' => [__($result['message']) ?? ""]];
                return Helpers::error($error, $data);
            }
        } catch (Exception $e) {
            $errorData = json_decode($e->getMessage(), true);
            $error = ['error' => [__($errorData['message'] ?? __("Something went wrong! Please try again."))]];
            return Helpers::error($error);
        }
    }

    public function notifications(){
        $notifications = UserNotification::auth()->latest()->get()->map(function($item){
            return[
                'id'         => $item->id,
                'type'       => $item->type,
                'title'      => $item->message->title??"",
                'message'    => $item->message->message??"",
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,

            ];
        });
        $data =[
            'notifications'  => $notifications
        ];
        $message =  ['success'=>[__('User Notifications')]];
        return Helpers::success($data,$message);
    }
}
