@extends('user.layouts.master')

@section('breadcrumb')
    @include('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __(@$page_title)])
@endsection

@section('content')
<div class="body-wrapper">
    <div class="deposit-wrapper ptb-50">
         @if(isset($card_customer))
            @if(isset($card_customer->status) && $card_customer->status ==  global_const()::CARD_CUSTOMER_APPROVED_STATUS)
                <div class="dashboard-header-wrapper d-flex justify-content-end">
                    <a href="{{ setRoute('user.cardyfie.virtual.card.edit.customer') }}" class="btn--base btn delete-btn text-end">{{ __("Update Customer") }}</a>
                </div>
            @endif
        @endif
        <div class="row justify-content-center">
            {{-- create card customer  --}}
            @if($card_customer == null)
                @include('user.sections.virtual-card-cardyfie.component.create-customer')
            @endif
            {{-- check and update for customer  --}}
            @if(isset($card_customer) )
                @if(isset($card_customer->status) && $card_customer->status ==  global_const()::CARD_CUSTOMER_PENDING_STATUS || $card_customer->status ==  global_const()::CARD_CUSTOMER_REJECTED_STATUS)
                    @include('user.sections.virtual-card-cardyfie.component.check-customer-status')
                @endif
            @endif
            {{-- Create card  --}}
            @if(isset($card_customer))
                @if(isset($card_customer->status) && $card_customer->status ==  global_const()::CARD_CUSTOMER_APPROVED_STATUS)
                    @include('user.sections.virtual-card-cardyfie.component.create-card')
                @endif
            @endif
        </div>
    </div>
</div>
@endsection

@push('script')
@if(isset($card_customer))
    @if(isset($card_customer->status) && $card_customer->status ==  global_const()::CARD_CUSTOMER_APPROVED_STATUS)
        <script>
        var defualCurrency = "{{ get_default_currency_code() }}";
        var defualCurrencyRate = "{{ get_default_currency_rate() }}";
        $(document).ready(function(){
           getExchangeRate();
           getFees();
           getPreview();
       });
       $("input[name=card_amount]").keyup(function(){
           getFees();
           getPreview();
       });

       $("select[name=currency]").change(function(){
           getExchangeRate();
           getFees();
           getPreview();
       });
       $("select[name=from_currency]").change(function(){
           getExchangeRate();
           getFees();
           getPreview();
       });

       $("select[name=card_tier]").change(function(){
           getExchangeRate();
           getFees();
           getPreview();
       });
       $("select[name=card_type]").change(function(){
           getPreview();
       });

       function acceptVar() {
           var defualCurrency          = defualCurrency;
           var defualCurrencyRate      = defualCurrencyRate;

           var cCurrencySelected       = $("select[name=currency] :selected");
           var currencyCode            = $("select[name=currency] :selected").val();
           var currencyRate            = $("select[name=currency] :selected").data('rate');

           var fCurrencySelected       = $("select[name=from_currency] :selected");
           var fCurrencyCode           = $("select[name=from_currency] :selected").val();
           var fCurrencyRate           = $("select[name=from_currency] :selected").data('rate');
           var senderCurrencyType      = $("select[name=from_currency] :selected").data('type');

           var cardType                 = $("select[name=card_tier] :selected").val();
           var cardProvider             = $("select[name=card_type] :selected").val();


           var currencyMinAmount    = "{{getAmount($cardCharge->min_limit)}}";
           var currencyMaxAmount    = "{{getAmount($cardCharge->max_limit)}}";
           var currencyDailyLimit   = "{{getAmount($cardCharge->daily_limit)}}";
           var currencyMonthlyLimit = "{{getAmount($cardCharge->monthly_limit)}}";

           var universal_card_issues_fee = "{{getAmount($cardCharge->universal_card_issues_fee)}}";
           var platinum_card_issues_fee = "{{getAmount($cardCharge->platinum_card_issues_fee)}}";

           if(senderCurrencyType == "CRYPTO"){
               var senderPrecison = "{{ get_precision_from_admin()['crypto_precision_value'] }}";
           }else{
               var senderPrecison = "{{  get_precision_from_admin()['fiat_precision_value'] }}";
           }

           return {
               defualCurrency:defualCurrency,
               defualCurrencyRate:defualCurrencyRate,

               cCurrencySelected:cCurrencySelected,
               currencyCode:currencyCode,
               currencyRate:currencyRate,

               cardType:cardType,
               cardProvider:cardProvider,

               fCurrencySelected:fCurrencySelected,
               fCurrencyCode:fCurrencyCode,
               fCurrencyRate:fCurrencyRate,
               sPrecison:senderPrecison,

               currencyMinAmount:currencyMinAmount,
               currencyMaxAmount:currencyMaxAmount,
               currencyDailyLimit:currencyDailyLimit,
               currencyMonthlyLimit:currencyMonthlyLimit,

               universalCardIssuesFee:universal_card_issues_fee,
               platinumCardIssuesFee:platinum_card_issues_fee,


           };
       }
       function getExchangeRate(){
           var card_currency = acceptVar().currencyCode;
           var card_currency_rate = acceptVar().currencyRate;

           var from_currency = acceptVar().fCurrencyCode;
           var from_currency_rate = acceptVar().fCurrencyRate;

           var rate =  parseFloat(from_currency_rate)/parseFloat(card_currency_rate);
           $('.exchange-rate').html("1 " + card_currency + " = " + parseFloat(rate).toFixed(acceptVar().sPrecison) + " " + from_currency);

           return rate;
       }


       function feesCalculation() {
           var from_currency_rate = acceptVar().fCurrencyRate;
           var exchange_rate = getExchangeRate();
           var sender_amount = $("input[name=card_amount]").val();
           if( acceptVar().cardType == 'universal'){
               var fixed_charge = acceptVar().universalCardIssuesFee;
           }else if(acceptVar().cardType == 'platinum'){
               var fixed_charge = acceptVar().platinumCardIssuesFee;
           }
           var percent_charge = 0;

           if ($.isNumeric(percent_charge) && $.isNumeric(fixed_charge) ) {
               // Process Calculation
               var fixed_charge_calc = parseFloat(fixed_charge) * parseFloat(exchange_rate);
               var percent_charge_calc = percent_charge;
               var total_charge = parseFloat(fixed_charge_calc) + parseFloat(percent_charge_calc);
               total_charge = parseFloat(total_charge).toFixed(acceptVar().sPrecison);
               // return total_charge;
               return {
                   total: parseFloat(total_charge).toFixed(acceptVar().sPrecison),
                   fixed: parseFloat(fixed_charge_calc).toFixed(acceptVar().sPrecison),
                   percent: parseFloat(percent_charge).toFixed(acceptVar().sPrecison),
               };
           } else {
               // return "--";
               return false;
           }
       }
       function getFees() {
           var from_currency = acceptVar().fCurrencyCode;
           var charges = feesCalculation();
           if (charges == false) {
               return false;
           }
           console.log(charges);

           $(".fees-show").html("{{ __('Fees') }}: " + parseFloat(charges.total).toFixed(acceptVar().sPrecison) + " " + from_currency );
       }
    function getPreview() {
            var exchange_rate = getExchangeRate();
            var card_currency = acceptVar().currencyCode;
            var from_currency = acceptVar().fCurrencyCode;
            // Fees
            var charges = feesCalculation();

            $('.fees').html( parseFloat(charges.total).toFixed(acceptVar().sPrecison) + " " + from_currency);
            $('.p-card-type').text( acceptVar().cardProvider.replace(/\b\w/g, l => l.toUpperCase()));
            $('.card_tier_preview').text(" (" + acceptVar().cardType.replace(/\b\w/g, l => l.toUpperCase()) + ")");
            $('.payable-total').html(parseFloat(charges.total).toFixed(acceptVar().sPrecison) + " " + from_currency);
       }



    </script>
    @endif
@endif
@endpush
