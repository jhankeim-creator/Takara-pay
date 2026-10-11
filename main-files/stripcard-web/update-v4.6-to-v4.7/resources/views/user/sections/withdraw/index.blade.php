@extends('user.layouts.master')

@push('css')

@endpush

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
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8 pb-30">
                <div class="deposit-form">
                    <div class="form-title text-center">
                        <h3 class="title">{{ __($page_title) }}</h3>
                    </div>
                    <div class="row justify-content-center">
                        <form class="card-form" action="{{ setRoute("user.withdraw.submit") }}" method="POST">
                            @csrf
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label>{{ __("Payment Gateway") }}<span>*</span></label>
                                    <div class="method">
                                    <select class="form--control nice-select gateway-select" name="gateway">
                                        @foreach ($payment_gateways ?? [] as $item)
                                            <option
                                                value="{{ $item->alias  }}"
                                                data-currency="{{ $item->currency_code }}"
                                                data-min_amount="{{ $item->min_limit }}"
                                                data-max_amount="{{ $item->max_limit }}"
                                                data-percent_charge="{{ $item->percent_charge }}"
                                                data-fixed_charge="{{ $item->fixed_charge }}"
                                                data-rate="{{ $item->rate }}"
                                                data-crypto="{{ $item->gateway->crypto}}"
                                                data-daily_limit="{{ $item->daily_limit}}"
                                                data-monthly_limit="{{ $item->monthly_limit}}"
                                                data-currency-id="{{ $item->id}}"
                                                >
                                                {{ $item->name }}
                                            </option>
                                        @endforeach
                                    </select>
                                    </div>

                            </div>
                            <div class="form-group">
                                <label>{{ __("Enter Amount") }}<span>*</span></label>
                                <input type="number" required class="form--control" placeholder="{{ __("Enter Amount") }}" name="amount" value="{{ old("amount") }}">
                                <select class="currency nice-select" name="wallet_currency">
                                    <option value="{{ get_default_currency_code() }}">{{ get_default_currency_code() }}</option>
                                </select>

                            </div>
                            <div class="note-area d-flex justify-content-between">
                                <div class="d-block">{{ __("Available Balance") }} {{ authWalletBalance() }} {{ get_default_currency_code() }}</div>
                                <div class="d-block fees-show">--</div>
                            </div>
                                <div class="button pt-3">
                                <button type="submit" class="btn--base w-100 btn-loading sendBtn">{{ __("Confirm") }}</i></button>
                                </div>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-8">
                <div class="deposit-form">
                    <div class="form-title text-center pb-4">
                        <h3 class="title">{{ __($page_title) }} {{ __("preview") }}</h3>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{ __("Enter Amount") }}</p>
                        </div>
                        <div class="preview-content">
                            <p class="request-amount"> </p>
                        </div>
                    </div>

                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{ __("Exchange Rate") }}</p>
                        </div>
                        <div class="preview-content">
                            <p class="rate-show">--</p>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{__("Fees & Charges")}}</p>
                        </div>
                        <div class="preview-content">
                            <p class="fees">--</p>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{__("Conversion Amount")}}</p>
                        </div>
                        <div class="preview-content">
                            <p class="conversionAmount">--</p>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{__("Will Get")}}</p>
                        </div>
                        <div class="preview-content">
                            <p class="will-get">--</p>
                        </div>
                    </div>

                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{ __("Total Payable Amount") }}</p>
                        </div>
                        <div class="preview-content">
                            <p class="pay-in-total">--</p>
                        </div>
                    </div>

                </div>
                {{-- limit section  --}}
                <div class="deposit-form my-3">
                    <div class="form-title text-center pb-4">
                        <h3 class="title">{{__("Limit Information")}}</h3>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <span>{{ __("Transaction Limit") }}</span>
                        </div>
                        <div class="preview-content">
                            <span class="limit-show">--</span>
                        </div>
                    </div>

                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <span>{{ __("Daily Limit") }}</span>
                        </div>
                        <div class="preview-content">
                            <span class="limit-daily">--</span>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <span>{{ __("Remaining Daily Limit") }}</span>
                        </div>
                        <div class="preview-content">
                            <span class="daily-remaining">--</span>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <span>{{ __("Monthly Limit") }}</span>
                        </div>
                        <div class="preview-content">
                            <span class="limit-monthly">--</span>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <span>{{ __("Remaining Monthly Limit") }}</span>
                        </div>
                        <div class="preview-content">
                            <span class="monthly-remaining">--</span>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-area mt-20">
        <div class="dashboard-header-wrapper">
            <h4 class="title">{{ __("Withdraw Money Log") }}</h4>
            <div class="dashboard-btn-wrapper">
                <div class="dashboard-btn mb-2">
                    <a href="{{ setRoute('user.transactions.index','withdraw-money') }}" class="btn--base">{{__("View More")}}</a>
                </div>
            </div>
        </div>
        <div class="dashboard-list-wrapper">
            @include('user.components.transaction-log',compact("transactions"))
        </div>
    </div>

</div>
@endsection

@push('script')
    <script>
        var defualCurrency = "{{ get_default_currency_code() }}";
        var defualCurrencyRate = "{{ get_default_currency_rate() }}";
        var walletCurrencyType = "{{ get_default_currency()->type }}";
        var walletCurrencyId = "{{ get_default_currency()->id }}";


        $('select[name=gateway]').on('change',function(){
            getExchangeRate();
            isCrypto();
            getLimit();
            getFees();
            getPreview();
            getDailyMonthlyLimit();
            get_remaining_limits();
        });
        $(document).ready(function(){
            getExchangeRate();
            isCrypto();
            getLimit();
            getFees();
            getPreview();
            getDailyMonthlyLimit();
            get_remaining_limits();
        });
        $("input[name=amount]").keyup(function(){
             getFees();
             getPreview();
        });
        $("input[name=amount]").focusout(function(){
            enterLimit();
        });

        function acceptVar() {
            var selectedVal = $("select[name=gateway] :selected");
            var currencyCode = $("select[name=gateway] :selected").attr("data-currency");
            var currencyRate = $("select[name=gateway] :selected").attr("data-rate");
            var currencyMinAmount = $("select[name=gateway] :selected").attr("data-min_amount");
            var currencyMaxAmount = $("select[name=gateway] :selected").attr("data-max_amount");
            var currencyFixedCharge = $("select[name=gateway] :selected").attr("data-fixed_charge");
            var currencyPercentCharge = $("select[name=gateway] :selected").attr("data-percent_charge");
            var currencyDailyLimit      = $("select[name=gateway] :selected").attr("data-daily_limit");
            var currencyMonthlyLimit    = $("select[name=gateway] :selected").attr("data-monthly_limit");

            if(walletCurrencyType == "CRYPTO"){
                var walletPrecison = "{{ get_precision_from_admin()['crypto_precision_value'] }}";
            }else{
                var walletPrecison = "{{  get_precision_from_admin()['fiat_precision_value'] }}";
            }

            return {
                currencyCode:currencyCode,
                currencyRate:currencyRate,
                currencyMinAmount:currencyMinAmount,
                currencyMaxAmount:currencyMaxAmount,
                currencyFixedCharge:currencyFixedCharge,
                currencyPercentCharge:currencyPercentCharge,
                selectedVal:selectedVal,
                currencyDailyLimit:currencyDailyLimit,
                currencyMonthlyLimit:currencyMonthlyLimit,
                wPrecison:walletPrecison,

            };
        }
        function isCrypto(){
            var crypto = acceptVar().selectedVal.data('crypto');
            if(crypto == 1){
                 precision = "{{ get_precision_from_admin()['crypto_precision_value'] }}";
            }else{
                 precision = "{{ get_precision_from_admin()['fiat_precision_value'] }}";
            }
            return precision;
        }
        function getExchangeRate() {
            var precision = isCrypto();
            var currencyCode = acceptVar().currencyCode;
            var currencyRate = parseFloat(acceptVar().currencyRate);
            $('.rate-show').html("1 " + defualCurrency + " = " + parseFloat(currencyRate).toFixed(precision) + " " + currencyCode);
            return currencyRate;
        }
        function getLimit() {
            var sender_currency = acceptVar().currencyCode;
            var sender_currency_rate = parseFloat(acceptVar().currencyRate);

            var min_limit = parseFloat(acceptVar().currencyMinAmount);
            var max_limit = parseFloat(acceptVar().currencyMaxAmount);

            if($.isNumeric(min_limit) || $.isNumeric(max_limit)) {
                var min_limit_calc = parseFloat(min_limit/sender_currency_rate).toFixed(acceptVar().wPrecison);
                var max_limit_clac = parseFloat(max_limit/sender_currency_rate).toFixed(acceptVar().wPrecison);

                $('.limit-show').html( min_limit_calc + " " + defualCurrency + " - " + max_limit_clac + " " + defualCurrency);
                return {
                    minLimit:min_limit_calc,
                    maxLimit:max_limit_clac,
                };
            }else {
                $('.limit-show').html("--");
                return {
                    minLimit:0,
                    maxLimit:0,
                };
            }
        }
        function enterLimit(){
            var sender_currency_rate = acceptVar().currencyRate;
            var min_limit = parseFloat(acceptVar().currencyMinAmount);
            var max_limit = parseFloat(acceptVar().currencyMaxAmount);


            if($.isNumeric(min_limit) || $.isNumeric(max_limit)) {
                var min_limit_calc = parseFloat(min_limit/sender_currency_rate).toFixed(acceptVar().wPrecison);
                var max_limit_clac = parseFloat(max_limit/sender_currency_rate).toFixed(acceptVar().wPrecison);

            }
            var sender_amount = parseFloat($("input[name=amount]").val()).toFixed(acceptVar().wPrecison);


            if( parseFloat(sender_amount) < parseFloat(min_limit_calc) ){
                throwMessage('error',["{{ __('Please follow the mimimum limit') }}"]);
                $('.sendBtn').attr('disabled',true)
            }else if(parseFloat(sender_amount) > parseFloat(max_limit_clac)){
                throwMessage('error',["{{ __('Please follow the maximum limit') }}"]);
                $('.sendBtn').attr('disabled',true)
            }else{
                $('.sendBtn').attr('disabled',false)
            }

        }


        function feesCalculation() {
             var precision = isCrypto();
            var sender_currency = acceptVar().currencyCode;
            var sender_currency_rate = parseFloat(acceptVar().currencyRate);

            var sender_amount = $("input[name=amount]").val();
            sender_amount == "" ? (sender_amount = 0) : (sender_amount = sender_amount);
            var conversion_amount = parseFloat( sender_amount) *  parseFloat(sender_currency_rate)

            var fixed_charge = parseFloat(acceptVar().currencyFixedCharge);
            var percent_charge = parseFloat(acceptVar().currencyPercentCharge);

            if ($.isNumeric(percent_charge) && $.isNumeric(fixed_charge) && $.isNumeric(conversion_amount)) {
                // Process Calculation
                var fixed_charge_calc = parseFloat(fixed_charge)/sender_currency_rate;
                var percent_charge_calc = (parseFloat(sender_amount) / 100) * parseFloat(percent_charge);
                var total_charge = parseFloat(fixed_charge_calc) + parseFloat(percent_charge_calc);
                total_charge = parseFloat(total_charge).toFixed(acceptVar().wPrecison);

                // return total_charge;
                return {
                    total: total_charge,
                    fixed: fixed_charge_calc,
                    percent: percent_charge,
                };
            } else {
                // return "--";
                return false;
            }
        }

        function getFees() {
            var sender_currency = acceptVar().currencyCode;
            var percent = acceptVar().currencyPercentCharge;
            var charges = feesCalculation();
            if (charges == false) {
                return false;
            }
            $(".fees-show").html("{{ __('Charge') }}: " + parseFloat(charges.fixed).toFixed(acceptVar().wPrecison) + " " + defualCurrency + " + " + parseFloat(charges.percent).toFixed(acceptVar().wPrecison) + "%");
        }
        function getPreview() {
            var precision = isCrypto();
            var senderAmount = $("input[name=amount]").val();
            var sender_currency = acceptVar().currencyCode;
            var sender_currency_rate = parseFloat( acceptVar().currencyRate);

            // var receiver_currency = acceptVar().rCurrency;
            senderAmount == "" ? senderAmount = 0 : senderAmount = senderAmount;

            // Sending Amount
            $('.request-amount').text(parseFloat(senderAmount).toFixed(acceptVar().wPrecison) + " " + defualCurrency);

            // Fees
            var charges = feesCalculation();
            $('.fees').text(charges.total + " " + defualCurrency);

            var conversionAmount = senderAmount * sender_currency_rate;
            $('.conversionAmount').text(parseFloat(conversionAmount).toFixed(precision) + " " + sender_currency);
            // will get amount
            var willGetAmount = parseFloat(senderAmount) * parseFloat(sender_currency_rate);
            var willGet = parseFloat(willGetAmount).toFixed(precision);
            $('.will-get').text(willGet + " " + sender_currency);

            // Pay In Total
            var totalPay = parseFloat(senderAmount);
                var pay_in_total = parseFloat(charges.total) + parseFloat(totalPay);
            $('.pay-in-total').text(parseFloat(pay_in_total).toFixed(acceptVar().wPrecison) + " " + defualCurrency);

        }


        function getDailyMonthlyLimit(){
            var pricison = isCrypto();
            var wCurrencyCode   = defualCurrency;
            var exchange_rate   = getExchangeRate();
            var daily_limit     = acceptVar().currencyDailyLimit;
            var monthly_limit   = acceptVar().currencyMonthlyLimit;


            if($.isNumeric(daily_limit) && $.isNumeric(monthly_limit)) {
                if(daily_limit > 0 ){
                    var daily_limit_calc = parseFloat(daily_limit / exchange_rate).toFixed(acceptVar().wPrecison);
                    $('.limit-daily').html( daily_limit_calc + " " + wCurrencyCode);
                }else{
                    $('.limit-daily').html("{{ __('Unlimited') }}");
                }

                if(monthly_limit > 0 ){
                    var montly_limit_clac = parseFloat(monthly_limit / exchange_rate).toFixed(acceptVar().wPrecison);
                    $('.limit-monthly').html( montly_limit_clac + " " + wCurrencyCode);

                }else{
                    $('.limit-monthly').html("{{ __('Unlimited') }}");
                }

            }else {
                $('.limit-daily').html("--");
                $('.limit-monthly').html("--");
                return {
                    dailyLimit:0,
                    monthlyLimit:0,
                };
            }

        }
        function get_remaining_limits(){
            var csrfToken           = $('meta[name="csrf-token"]').attr('content');
            var user_field          = "user_id";
            var user_id             = "{{ userGuard()['user']->id }}";
            var transaction_type    = "{{ payment_gateway_const()::WITHDRAWMONEY }}";
            var currency_id         = walletCurrencyId;
            var sender_amount       = $("input[name=amount]").val();

            (sender_amount == "" || isNaN(sender_amount)) ? sender_amount = 0 : sender_amount = sender_amount;

            var charge_id           = acceptVar().selectedVal.data('currency-id');
            var attribute           = "{{ payment_gateway_const()::SEND }}";

            $.ajax({
                type: 'POST',
                url: "{{ route('global.get.total.transactions') }}",
                data: {
                    _token:             csrfToken,
                    user_field:         user_field,
                    user_id:            user_id,
                    transaction_type:   transaction_type,
                    currency_id:        currency_id,
                    sender_amount:      sender_amount,
                    charge_id:          charge_id,
                    attribute:          attribute,
                },
                success: function(response) {
                    var sender_currency = defualCurrency;
                    var daily_limit = acceptVar().currencyDailyLimit;
                    var monthly_limit = acceptVar().currencyMonthlyLimit


                    var status  = response.status;
                    var message = response.message;
                    var amount_data = response.data;

                    if(status == false){
                        $('.withdrawBtn').attr('disabled',true);
                        if(daily_limit > 0){
                            $('.daily-remaining').html(amount_data.remainingDailyTxnSelected + " " + sender_currency);
                            throwMessage('error',[message]);
                            return false;
                        }else{
                            $('.daily-remaining').html("{{ __('Unlimited') }}");
                        }
                        if(monthly_limit > 0){
                            $('.monthly-remaining').html(amount_data.remainingMonthlyTxnSelected + " " + sender_currency);
                            throwMessage('error',[message]);
                            return false;
                        }else{
                            $('.monthly-remaining').html("{{ __('Unlimited') }}");
                        }

                    }else{
                        $('.withdrawBtn').attr('disabled',false);
                        if(daily_limit > 0){
                            $('.daily-remaining').html(amount_data.remainingDailyTxnSelected + " " + sender_currency);
                        }else{
                            $('.daily-remaining').html("{{ __('Unlimited') }}");
                        }
                        if(monthly_limit > 0){
                            $('.monthly-remaining').html(amount_data.remainingMonthlyTxnSelected + " " + sender_currency);
                        }else{
                            $('.monthly-remaining').html("{{ __('Unlimited') }}");
                        }
                    }
                },
            });
        }
    </script>
@endpush
