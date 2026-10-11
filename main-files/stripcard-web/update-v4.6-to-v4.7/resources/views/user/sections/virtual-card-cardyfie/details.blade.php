@extends('user.layouts.master')

@push('css')
    <link rel="stylesheet" href="{{ asset('frontend/css/virtual-card.css') }}">
    <style>
        .btn-ring {
            position: absolute;
            top: 0px;
            right: 0px;

        }
    </style>
@endpush

@section('breadcrumb')
    @include('user.components.breadcrumb', [
        'breadcrumbs' => [
            [
                'name' => __('Dashboard'),
                'url' => setRoute('user.dashboard'),
            ],
        ],
        'active' => __(@$page_title),
    ])
@endsection

@section('content')
    <div class="body-wrapper ptb-40">
        <div class="row">
            <div class="col-xxl-6 col-xl-8 col-lg-10 col-md-12 col-sm-12 mb-40">
                <div class="card-item">
                    <div class="card-wrapper">
                        <div class="card-custom-area justify-content-center">
                            <div class="backgound">
                                <div class="left"></div>
                                <div class="right"></div>
                            </div>

                            <div class="card-custom">
                                <div class="flip">
                                    <div class="front bg_img"
                                        data-background="{{ get_image(@$cardApi->image, 'card-api') }}">
                                        <img class="logo" src="{{ get_fav($basic_settings) }}" alt="site-logo">
                                        <div class="investor">{{ @$basic_settings->site_name }}</div>
                                        <div class="chip">
                                            <div class="chip-line"></div>
                                            <div class="chip-line"></div>
                                            <div class="chip-line"></div>
                                            <div class="chip-line"></div>
                                            <div class="chip-main"></div>
                                        </div>
                                        <svg class="wave" viewBox="0 3.71 26.959 38.787" width="26.959" height="38.787"
                                            fill="white">
                                            <path
                                                d="M19.709 3.719c.266.043.5.187.656.406 4.125 5.207 6.594 11.781 6.594 18.938 0 7.156-2.469 13.73-6.594 18.937-.195.336-.57.531-.957.492a.9946.9946 0 0 1-.851-.66c-.129-.367-.035-.777.246-1.051 3.855-4.867 6.156-11.023 6.156-17.718 0-6.696-2.301-12.852-6.156-17.719-.262-.317-.301-.762-.102-1.121.204-.36.602-.559 1.008-.504z">
                                            </path>
                                            <path
                                                d="M13.74 7.563c.231.039.442.164.594.343 3.508 4.059 5.625 9.371 5.625 15.157 0 5.785-2.113 11.097-5.625 15.156-.363.422-1 .472-1.422.109-.422-.363-.472-1-.109-1.422 3.211-3.711 5.156-8.551 5.156-13.843 0-5.293-1.949-10.133-5.156-13.844-.27-.309-.324-.75-.141-1.114.188-.367.578-.582.985-.542h.093z">
                                            </path>
                                            <path
                                                d="M7.584 11.438c.227.031.438.144.594.312 2.953 2.863 4.781 6.875 4.781 11.313 0 4.433-1.828 8.449-4.781 11.312-.398.387-1.035.383-1.422-.016-.387-.398-.383-1.035.016-1.421 2.582-2.504 4.187-5.993 4.187-9.875 0-3.883-1.605-7.372-4.187-9.875-.321-.282-.426-.739-.266-1.133.164-.395.559-.641.984-.617h.094zM1.178 15.531c.121.02.238.063.344.125 2.633 1.414 4.437 4.215 4.437 7.407 0 3.195-1.797 5.996-4.437 7.406-.492.258-1.102.07-1.36-.422-.257-.492-.07-1.102.422-1.359 2.012-1.075 3.375-3.176 3.375-5.625 0-2.446-1.371-4.551-3.375-5.625-.441-.204-.676-.692-.551-1.165.122-.468.567-.785 1.051-.742h.094z">
                                            </path>
                                        </svg>
                                        @php
                                            $card_number = str_split(
                                                remove_special_char($card_api['real_pan'] ?? $card_api['masked_pan']),
                                                4,
                                            );
                                        @endphp
                                        <div class="card-number">
                                            @foreach ($card_number as $key => $value)
                                                <div class="section">{{ $value }}</div>
                                            @endforeach
                                        </div>

                                        <div class="end"><span class="end-text">{{ __('exp. end') }}:</span><span
                                                class="end-date"> {{ $myCard->card_exp_time }}</span>
                                        </div>
                                        <div class="card-holder">{{ $myCard->card_name }}</div>
                                        <div class="master">
                                            @if ($myCard->card_type == 'visa')
                                                <img src="{{ get_image('frontend/images/card/visa-logo.png') }}"
                                                    alt="card">
                                            @else
                                                <img src="{{ get_image('frontend/images/card/Mastercard-logo.png') }}"
                                                    alt="card">
                                            @endif
                                        </div>
                                    </div>
                                    <div class="back">
                                        <div class="strip-black"></div>
                                        <div class="ccv">
                                            <label>{{ __('ccv') }}</label>
                                            <div>{{ $card_api['cvv'] ?? '***' }}</div>
                                        </div>
                                        <div class="terms">
                                            @php
                                                echo @$card_details->card_details;
                                            @endphp
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="virtual-card-btn-area text-center pt-20">
                            @if ($myCard['is_default'] == true)
                                <a href="javascript:void(0)" class="btn--base active-deactive-btn"
                                    data-id="{{ $myCard['id'] }}">
                                    <i class="fas fa-star me-1 me-1"></i>
                                    {{ __('remove Default') }}</a>
                            @else
                                <a href="javascript:void(0)" class="btn--base active-deactive-btn"
                                    data-id="{{ $myCard['id'] }}">
                                    <i class="fas fa-star me-1 me-1"></i>
                                    {{ __('make Default') }}</a>
                            @endif


                            <a href="{{ setRoute('user.cardyfie.virtual.card.deposit.page', $myCard->ulid) }}"
                                class="btn--base">
                                <i class="fas fa-arrow-down me-1"></i>
                                {{ __('deposit') }}</a>


                            <a href="{{ setRoute('user.cardyfie.virtual.card.withdraw.page', $myCard->ulid) }}"
                                class="btn--base">
                                <i class="fas fa-arrow-up me-1"></i>
                                {{ __('withdraw') }}</a>

                            <a href="{{ setRoute('user.cardyfie.virtual.card.transaction', $myCard->ulid) }}"
                                class="btn--base">
                                <i class="fas fa-arrows-alt-h me-1"></i> {{ __('Transactions') }}</a>
                            @if ($myCard->status != global_const()::CARD_CLOSED_STATUS)
                                <a href="javascript:void(0)" class="btn--danger close-card" data-id="{{ $myCard['id'] }}">
                                    <i class="fas fa-times  me-1"></i> {{ __('Close') }}</a>
                            @endif
                        </div>

                    </div>
                </div>
            </div>
            <div class="col-xxl-6 col-xl-4 col-lg-4 col-md-5 col-sm-12 mb-40">
                <div class="card-item">
                    <div class="card-wrapper">
                        <div class="billing-heading">
                            <h3 class="title text-center">{{ __('Address') }}</h3>
                        </div>
                        <ul class="billing-list">
                            <li>
                                <span>{{ __('Billing Address') }}</span>
                                <h6>{{ __($myCard->address) }}</h6>
                            </li>

                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-xxl-10 col-xl-10 col-lg-8 col-md-7 col-sm-12 mb-40">
                <div class="card-prevew pt-2">
                    <div class="preview-list-wrapper">
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-credit-card"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Name') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span class="text--base">{{ $myCard->card_name }}</span>
                            </div>
                        </div>

                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-id-card-alt"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Id') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span>{{ @$myCard->ulid }}</span>
                            </div>
                        </div>

                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-hand-holding-heart"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Amount') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span
                                    class="text--base">{{ get_amount($myCard->amount, $myCard->currency, get_wallet_precision()) }}</span>
                            </div>
                        </div>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-crown"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Tier') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span class="text--base">{{ __(ucwords(@$myCard->card_tier)) }}</span>
                            </div>
                        </div>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-list"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Type') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span class="text--base">{{ __(ucwords(@$myCard->card_type)) }}</span>
                            </div>
                        </div>

                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-user-tag"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('customer Id') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span>{{ @$myCard->customer_ulid }}</span>
                            </div>
                        </div>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-sort-numeric-down"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Card Number') }}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="preview-list-right">
                                @php
                                    $card_pan = str_split(
                                        remove_special_char(
                                            $card_api['real_pan'] ?? ($myCard->real_pan ?? $card_api['masked_pan']),
                                        ),
                                        4,
                                    );
                                @endphp
                                @foreach ($card_pan as $key => $value)
                                    <span>{{ @$value }}</span>
                                @endforeach
                            </div>
                        </div>


                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-ellipsis-h"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Cvv') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span>{{ __($card_api['cvv'] ?? ($myCard->cvv ?? '***')) }}</span>
                            </div>
                        </div>
                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-calendar"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Expiration') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span>{{ @$myCard->card_exp_time }}</span>
                            </div>
                        </div>


                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-stream"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Payment OTP') }}</span>
                                    </div>
                                </div>
                            </div>
                            @php
                                use Carbon\Carbon;
                                $payment_expiry = Carbon::parse($myCard->payment_expiry);
                            @endphp
                            <div class="preview-list-right">
                            @if ($myCard->payment_otp)
                                <span class="text--success d-block">
                                    {{ $myCard->payment_otp ?? 'N/A' }}
                                </span>
                                    <small>
                                        @if (!$payment_expiry->isPast())
                                        ({{ __('Remaining time') }}:<span class="otp-countdown"
                                        data-expiry="{{ $payment_expiry->timestamp }}"></span>)
                                        @endif
                                    </small>
                            @else
                                <span>{{ __('N/A') }}</span>
                            @endif
                            </div>
                        </div>


                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-stream"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('Wallet OTP') }}</span>
                                    </div>
                                </div>
                            </div>
                            @php
                                $expiry = Carbon::parse($myCard->wallet_otp_expiry);
                            @endphp
                            <div class="preview-list-right">
                            @if ($myCard->wallet_otp)
                                <span class="text--success d-block">
                                    {{ $myCard->wallet_otp ?? 'N/A' }}
                                </span>
                                    <small>
                                        @if (!$expiry->isPast())
                                        ({{ __('Remaining time') }}:<span class="otp-countdown"
                                        data-expiry="{{ $expiry->timestamp }}"></span>)
                                        @endif
                                    </small>
                            @else
                                <span>{{ __('N/A') }}</span>
                            @endif
                            </div>
                        </div>

                        <div class="preview-list-item">
                            <div class="preview-list-left">
                                <div class="preview-list-user-wrapper">
                                    <div class="preview-list-user-icon">
                                        <i class="las la-stream"></i>
                                    </div>
                                    <div class="preview-list-user-content">
                                        <span>{{ __('appLCardEnvironment') }}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="preview-list-right">
                                <span>{{ $myCard->env }}</span>
                            </div>
                        </div>
                        @if ($myCard->status == global_const()::CARD_CLOSED_STATUS)
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-stream"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span>{{ __('Status') }}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right ">
                                    <span
                                        class="{{ $myCard->cardStatus->class }}">{{ $myCard->cardStatus->value }}</span>
                                </div>
                            </div>
                        @endif
                        @if ($myCard->status == global_const()::CARD_ENABLED_STATUS || $myCard->status == global_const()::CARD_FREEZE_STATUS)
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-thermometer-half"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span>{{ __('Status') }}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <div class="toggle-container">
                                        @include('admin.components.form.switcher', [
                                            'name' => 'status',
                                            'value' => old('status', @$myCard->status),
                                            'options' => [
                                                'UnFreeze ' => global_const()::CARD_ENABLED_STATUS,
                                                'Freeze' => global_const()::CARD_FREEZE_STATUS,
                                            ],
                                            'onload' => true,
                                            'data_target' => @$myCard->id,
                                        ])
                                    </div>
                                </div>
                            </div>
                        @endif

                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('script')
    <script>
        $(document).ready(function() {
            switcherAjax("{{ setRoute('user.cardyfie.virtual.card.change.status') }}");
        })
        $(".active-deactive-btn").click(function() {
            var actionRoute = "{{ setRoute('user.cardyfie.virtual.card.make.default.or.remove') }}";
            var target = $(this).data('id');
            var btnText = $(this).text();
            var message = `Are you sure to <strong>${btnText}</strong> this card?`;
            openAlertModal(actionRoute, target, message, btnText, "POST");
        });
        $(".close-card").click(function() {
            var actionRoute = "{{ setRoute('user.cardyfie.virtual.card.close') }}";
            var target = $(this).data('id');
            var btnText = $(this).text();
            var message = `Are you sure to  <strong>${btnText}</strong> this card?`;
            openAlertModal(actionRoute, target, message, btnText, "POST");
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {

            const countdowns = document.querySelectorAll('.otp-countdown');

            countdowns.forEach(el => {
                const expiryTime = parseInt(el.dataset.expiry) * 1000;

                const timer = setInterval(() => {
                    const now = new Date().getTime();
                    const diff = expiryTime - now;

                    if (diff <= 0) {
                        el.innerHTML = "Expired";
                        clearInterval(timer);
                        return;
                    }

                    const minutes = Math.floor(diff / (1000 * 60));
                    const seconds = Math.floor((diff % (1000 * 60)) / 1000);

                    el.innerHTML = `${minutes}m ${seconds}s`;
                }, 1000);
            });

        });
    </script>
@endpush
