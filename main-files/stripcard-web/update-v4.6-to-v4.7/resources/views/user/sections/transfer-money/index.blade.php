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
                        <form class="card-form" action="{{ setRoute("user.transfer.money.confirmed") }}" method="POST">
                            @csrf
                        <div class="col-lg-12">
                            <div class="form-group">
                                <label>{{ __("receiver Email") }}<span>*</span></label>
                                <input type="email" required class="form--control checkUser" placeholder="{{ __("receiver Email") }}" name="email" value="{{ old("email") }}">
                                <label class="exist text-start"></label>
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
                                <button type="submit" class="btn--base w-100 btn-loading transferBtn">{{ __("Confirm") }}</i></button>
                                </div>
                        </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-4">
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
                            <p>{{__("transfer Fee")}}</p>
                        </div>
                        <div class="preview-content">
                            <p class="fees">--</p>
                        </div>
                    </div>
                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{__("recipient Received")}}</p>
                        </div>
                        <div class="preview-content">
                            <p class="recipient-get">--</p>
                        </div>
                    </div>

                    <div class="preview-item d-flex justify-content-between">
                        <div class="preview-content">
                            <p>{{ __("Total Payable Amount") }}</p>
                        </div>
                        <div class="preview-content">
                            <p class="payable-total">--</p>
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
                    @if ($transferMoneyCharge->daily_limit > 0)
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
                    @endif
                    @if ($transferMoneyCharge->monthly_limit > 0)
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
                    @endif

                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-area mt-20">
        <div class="dashboard-header-wrapper">
            <h4 class="title">{{ __("Transfer Money Log") }}</h4>
            <div class="dashboard-btn-wrapper">
                <div class="dashboard-btn mb-2">
                    <a href="{{ setRoute('user.transactions.index','transfer-money') }}" class="btn--base">{{__("View More")}}</a>
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
      $('.checkUser').on('keyup',function(e){
            var url = '{{ route('user.transfer.money.check.exist') }}';
            var value = $(this).val();
            var token = '{{ csrf_token() }}';
            if ($(this).attr('name') == 'email') {
                var data = {email:value,_token:token}

            }
            $.post(url,data,function(response) {
                if(response.own){
                    if($('.exist').hasClass('text--success')){
                        $('.exist').removeClass('text--success');
                    }
                    $('.exist').addClass('text--danger').text(response.own);
                    $('.transferBtn').attr('disabled',true)
                    return false
                }
                if(response['data'] != null){
                    if($('.exist').hasClass('text--danger')){
                        $('.exist').removeClass('text--danger');
                    }
                    $('.exist').text(`Valid user for transfer money.`).addClass('text--success');
                    $('.transferBtn').attr('disabled',false)
                } else {
                    if($('.exist').hasClass('text--success')){
                        $('.exist').removeClass('text--success');
                    }
                    $('.exist').text('User doesn\'t  exists.').addClass('text--danger');
                    $('.transferBtn').attr('disabled',true)
                    return false
                }

            });
        });
    </script>

    <script>
    var defualCurrency      = "{{ get_default_currency_code() }}";
    var defualCurrencyRate  = "{{ get_default_currency_rate() }}";
    var senderCurrencyType  = "{{ get_default_currency()->type }}";
    var senderCurrencyId    = "{{ get_default_currency()->id }}";

    $(document).ready(function(){
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
        var currencyCode            = defualCurrency;
        var currencyRate            = defualCurrencyRate;
        var currencyMinAmount       ="{{getAmount($transferMoneyCharge->min_limit)}}"
        var currencyMaxAmount       = "{{getAmount($transferMoneyCharge->max_limit)}}"
        var currencyFixedCharge     = "{{getAmount($transferMoneyCharge->fixed_charge)}}"
        var currencyPercentCharge   = "{{getAmount($transferMoneyCharge->percent_charge)}}";
        var currencyDailyLimit      = "{{getAmount($transferMoneyCharge->daily_limit)}}";
        var currencyMonthlyLimit    = "{{getAmount($transferMoneyCharge->monthly_limit)}}";

            if(senderCurrencyType == "CRYPTO"){
                var senderPrecison = "{{ get_precision_from_admin()['crypto_precision_value'] }}";
            }else{
                var senderPrecison = "{{  get_precision_from_admin()['fiat_precision_value'] }}";
            }

        return {
            currencyCode:currencyCode,
            currencyRate:currencyRate,
            currencyMinAmount:currencyMinAmount,
            currencyMaxAmount:currencyMaxAmount,
            currencyFixedCharge:currencyFixedCharge,
            currencyPercentCharge:currencyPercentCharge,
            currencyDailyLimit:currencyDailyLimit,
            currencyMonthlyLimit:currencyMonthlyLimit,
            sPrecison:senderPrecison,
        };
    }
    function getLimit() {
        var currencyCode = acceptVar().currencyCode;
        var currencyRate = parseFloat(acceptVar().currencyRate);

        var min_limit = parseFloat(acceptVar().currencyMinAmount);
        var max_limit = parseFloat(acceptVar().currencyMaxAmount);
        if($.isNumeric(min_limit) || $.isNumeric(max_limit)) {
            var min_limit_calc = parseFloat(min_limit/currencyRate).toFixed(acceptVar().sPrecison);
            var max_limit_clac = parseFloat(max_limit/currencyRate).toFixed(acceptVar().sPrecison);
            $('.limit-show').html( min_limit_calc + " " + currencyCode + " - " + max_limit_clac + " " + currencyCode);

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
    function feesCalculation() {
        var currencyCode = acceptVar().currencyCode;
        var currencyRate = parseFloat(acceptVar().currencyRate);
        var sender_amount = $("input[name=amount]").val();
        sender_amount == "" ? (sender_amount = 0) : (sender_amount = sender_amount);

        var fixed_charge    = parseFloat(acceptVar().currencyFixedCharge);
        var percent_charge  = parseFloat(acceptVar().currencyPercentCharge);
        if ($.isNumeric(percent_charge) && $.isNumeric(fixed_charge) && $.isNumeric(sender_amount)) {
            // Process Calculation
            var fixed_charge_calc   = parseFloat(currencyRate * fixed_charge);
            var percent_charge_calc = parseFloat(currencyRate)*(parseFloat(sender_amount) / 100) * parseFloat(percent_charge);
            var total_charge = parseFloat(fixed_charge_calc) + parseFloat(percent_charge_calc);
            total_charge = parseFloat(total_charge).toFixed(acceptVar().sPrecison);
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
        var currencyCode = acceptVar().currencyCode;
        var charges = feesCalculation();
        if (charges == false) {
            return false;
        }
        $(".fees-show").html("{{ __('transfer Fee') }}: " + parseFloat(charges.fixed).toFixed(acceptVar().sPrecison) + " " + currencyCode + " + " + parseFloat(charges.percent).toFixed(acceptVar().sPrecison) + "%  ");
    }
    function getPreview() {
        var senderAmount            = $("input[name=amount]").val();
        var sender_currency         = acceptVar().currencyCode;
        var sender_currency_rate    = parseFloat(acceptVar().currencyRate);
        senderAmount == "" ? senderAmount = 0 : senderAmount = senderAmount;
        // Sending Amount
        $('.request-amount').text(parseFloat(senderAmount).toFixed(acceptVar().sPrecison) + " " + defualCurrency);

        // Fees
        var charges = feesCalculation();
        var total_charge = 0;
        if(senderAmount == 0){
            total_charge = parseFloat(0).toFixed(acceptVar().sPrecison);
        }else{
            total_charge = charges.total;
        }

        $('.fees').text(total_charge + " " + sender_currency);
        // // recipient received
        var recipient = parseFloat(senderAmount) * parseFloat(sender_currency_rate)
        var recipient_get = 0;
        if(senderAmount == 0){
            recipient_get = parseFloat(0).toFixed(acceptVar().sPrecison);
        }else{
            recipient_get =  parseFloat(recipient).toFixed(acceptVar().sPrecison);
        }
        $('.recipient-get').text(parseFloat(recipient_get).toFixed(acceptVar().sPrecison) + " " + sender_currency);

        // Pay In Total
        var totalPay = parseFloat(senderAmount) * parseFloat(sender_currency_rate)
        var pay_in_total = 0;
        if(senderAmount == 0){
            pay_in_total = parseFloat(0).toFixed(acceptVar().sPrecison);
        }else{
            pay_in_total =  parseFloat(totalPay) + parseFloat(charges.total);
        }
        $('.payable-total').text(parseFloat(pay_in_total).toFixed(acceptVar().sPrecison) + " " + sender_currency);

    }
    function enterLimit(){
        var sender_currency_rate = acceptVar().currencyRate;
        var min_limit = parseFloat(acceptVar().currencyMinAmount);
        var max_limit = parseFloat(acceptVar().currencyMaxAmount);
        if($.isNumeric(min_limit) || $.isNumeric(max_limit)) {
            var min_limit_calc = parseFloat(min_limit/sender_currency_rate).toFixed(acceptVar().sPrecison);
            var max_limit_clac = parseFloat(max_limit/sender_currency_rate).toFixed(acceptVar().sPrecison);
        }
        var sender_amount = parseFloat($("input[name=amount]").val()).toFixed(acceptVar().sPrecison);
        if( parseFloat(sender_amount) < parseFloat(min_limit_calc) ){
            throwMessage('error',["{{ __('Please follow the mimimum limit') }}"]);
            $('.transferBtn').attr('disabled',true)
        }else if(parseFloat(sender_amount) > parseFloat(max_limit_clac)){
            throwMessage('error',["{{ __('Please follow the maximum limit') }}"]);
            $('.transferBtn').attr('disabled',true)
        }else{
            $('.transferBtn').attr('disabled',false)
        }

    }

    function getDailyMonthlyLimit(){
        var sender_currency         = acceptVar().currencyCode;
        var sender_currency_rate    = parseFloat(acceptVar().currencyRate);
        var daily_limit             = parseFloat(acceptVar().currencyDailyLimit);
        var monthly_limit           = parseFloat(acceptVar().currencyMonthlyLimit);

        if($.isNumeric(daily_limit) && $.isNumeric(monthly_limit)) {
            if(daily_limit > 0 ){
                var daily_limit_calc = parseFloat(daily_limit * sender_currency_rate).toFixed(acceptVar().sPrecison);
                $('.limit-daily').html( daily_limit_calc + " " + sender_currency);
            }else{
                $('.limit-daily').html("");
            }

            if(monthly_limit > 0 ){
                var montly_limit_clac = parseFloat(monthly_limit * sender_currency_rate).toFixed(acceptVar().sPrecison);
                $('.limit-monthly').html( montly_limit_clac + " " + sender_currency);

            }else{
                $('.limit-monthly').html("");
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
        var transaction_type    = "{{ payment_gateway_const()::TYPETRANSFERMONEY }}";
        var currency_id         = senderCurrencyId;
        var sender_amount       = $("input[name=amount]").val();

        (sender_amount == "" || isNaN(sender_amount)) ? sender_amount = 0 : sender_amount = sender_amount;

        var charge_id           = "{{ $transferMoneyCharge->id }}";
        var attribute           = "{{ payment_gateway_const()::SEND }}"

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
                var sender_currency = acceptVar().currencyCode;

                var status  = response.status;
                var message = response.message;
                var amount_data = response.data;

                if(status == false){
                    $('.transfer').attr('disabled',true);
                    $('.daily-remaining').html(amount_data.remainingDailyTxnSelected + " " + sender_currency);
                    $('.monthly-remaining').html(amount_data.remainingMonthlyTxnSelected + " " + sender_currency);
                    throwMessage('error',[message]);
                    return false;
                }else{
                    $('.transfer').attr('disabled',false);
                    $('.daily-remaining').html(amount_data.remainingDailyTxnSelected + " " + sender_currency);
                    $('.monthly-remaining').html(amount_data.remainingMonthlyTxnSelected + " " + sender_currency);
                }
            },
        });
    }
    </script>
@endpush
