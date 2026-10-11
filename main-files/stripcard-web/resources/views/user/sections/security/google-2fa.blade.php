@extends('user.layouts.master')

@push('css')
@endpush

@section('breadcrumb')
    @include('user.components.breadcrumb', [
        'breadcrumbs' => [
            [
                'name' => __('Dashboard'),
                'url' => setRoute('user.dashboard'),
            ],
        ],
        'active' => __($page_title),
    ])
@endsection

@section('content')
    <div class="body-wrapper">
        <div class="row mb-30-none">
            <div class="col-xl-6 mb-30">
                <div class="dash-payment-item-wrapper">
                    <div class="dash-payment-item active">

                        <div class="card-body">
                            <form class="card-form">
                                <div class="row">
                                    <div class="col-xl-12 col-lg-12 form-group">
                                        <label>{{ __($page_title) }}</label>
                                        <div class="input-group">
                                            <input type="text" class="form--control" id="referralURL"
                                                value="{{ auth()->user()->two_factor_secret }}" readonly>
                                            <div class="input-group-text copytext" id="copyBoard"><i
                                                    class="las la-copy"></i></div>
                                        </div>
                                    </div>
                                    <div class="col-xl-12 col-lg-12 form-group">
                                        <div class="qr-code-thumb text-center qr-code m-auto border">
                                            {!! $qr_code !!}
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-12 col-lg-12">
                                    @if (auth()->user()->two_factor_status)
                                        <button type="button"
                                            class="btn--base bg--warning w-100 active-deactive-btn">{{ __('Disable') }}</button>
                                        <br>
                                        <div class="text--danger mt-3">
                                            {{ __("Don't forget to add this application in your google authentication app. Otherwise you can't login in your account.") }}
                                        </div>
                                    @else
                                        <button type="button"
                                            class="btn--base w-100 active-deactive-btn">{{ __('Enable') }}</button>
                                    @endif
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-6 mb-30">
                <div class="dash-payment-item-wrapper">
                    <div class="dash-payment-item active">
                        <div class="card-body">
                            <h4 class="mb-3">{{ __('Download Google Authenticator App') }}</h4>
                            <p>{{ __('Google Authenticator is a product based authenticator by Google that executes two-venture confirmation administrations for verifying clients of any programming applications') }}.
                            </p>
                            <div class="play-store-thumb text-center pb-20">
                                <img class="mx-auto"
                                    src="{{ get_image('frontend/images/element/google-authenticator.webp') }}">
                            </div>
                            <a href="https://play.google.com/store/apps" target="_blank"
                                class="btn--base mt-10 w-100">{{ __('Download App') }}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('script')
    <script>
        $(".active-deactive-btn").click(function() {
            var actionRoute = "{{ setRoute('user.security.google.2fa.status.update') }}";
            var target      = "{{ auth()->user()->id }}";
            var btnText     = $(this).text().trim();
            var csrf        = $("head meta[name=csrf-token]").attr("content");
            var promptText  = '{{ __("Enter the 6-digit code from your authenticator app to confirm.") }}';
            var codeLabel   = '{{ __("Authenticator code") }}';
            var content = `<div class="card twoFa-code-verify border-0">
                        <div class="card-body">
                            <form method="POST" action="${actionRoute}">
                                <input type="hidden" name="_token" value="${csrf}">
                                <input type="hidden" name="target" value="${target}">
                                <div class="head mb-3"><strong>${btnText}</strong> {{ __('(Powered by google)') }}</div>
                                <div class="form-group mb-3">
                                    <label class="mb-2">${codeLabel}</label>
                                    <input type="text" name="code" class="form-control" inputmode="numeric" autocomplete="one-time-code" maxlength="6" placeholder="000000" required autofocus>
                                    <small class="text--muted d-block mt-2">${promptText}</small>
                                </div>
                                <div class="foot d-flex align-items-center justify-content-between">
                                    <button type="button" class="modal-close btn btn--info rounded text-light">{{ __('Close') }}</button>
                                    <button type="submit" class="btn btn--base btn-loading rounded text-light">${btnText}</button>
                                </div>
                            </form>
                        </div>
                    </div>`;
            openModalByContent({content: content});
        });
        $('.copytext').on('click', function() {
            var copyText = document.getElementById("referralURL");
            copyText.select();
            copyText.setSelectionRange(0, 99999);
            document.execCommand("copy");

            throwMessage('success', ["{{ __('Copied') }}: " + copyText.value]);
        });
    </script>
@endpush
