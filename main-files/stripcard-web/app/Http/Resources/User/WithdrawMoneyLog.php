<?php

namespace App\Http\Resources\User;

use Illuminate\Http\Resources\Json\JsonResource;

class WithdrawMoneyLog extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $statusInfo = [
            "success" =>      1,
            "pending" =>      2,
            "rejected" =>     4,
            ];
        return[
            'id' => $this->id,
            'trx' => $this->trx_id,
            'gateway_name' => $this->currency->gateway->name,
            'gateway_currency_name' => $this->currency->name,
            'transaction_type' => __($this->type),
            'request_amount' => getAmount($this->request_amount,get_wallet_precision()).' '.get_default_currency_code() ,
            'exchange_rate' => '1 ' .get_default_currency_code().' = '.isCrypto(@$this->currency->rate??1,$this->currency->currency_code??get_default_currency_code(),$this->currency->gateway->crypto),
            'will_get' => isCrypto(@$this->details->withdraw_data->conversion_amount,$this->currency->currency_code??get_default_currency_code(),$this->currency->gateway->crypto),
            'total_charge' => getAmount($this->charge->total_charge,get_wallet_precision()).' '.get_default_currency_code(),
            'payable' => getAmount($this->payable,get_wallet_precision()).' '.get_default_currency_code(),
            'current_balance' => getAmount($this->available_balance,get_wallet_precision()).' '.get_default_currency_code(),
            'status' => $this->stringStatus->value ,
            'date_time' => $this->created_at ,
            'status_info' =>(object)$statusInfo ,
            'rejection_reason' =>$this->reject_reason??"" ,

        ];
    }
}
