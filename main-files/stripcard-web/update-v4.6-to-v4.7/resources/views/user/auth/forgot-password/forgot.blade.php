
@extends('frontend.layouts.master')
@php
    $lang           = selectedLang();
    $system_default = $default_language_code;
    $auth_slug      = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::AUTH_SECTION);
    $auth_data      = App\Models\Admin\SiteSections::getData( $auth_slug)->first();

@endphp
@section('content')
<section class="account-section forgot-password ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-9">
                <div class="account-login-form">
                    <form action="{{ setRoute('user.password.forgot.send.code') }}" class="card-form" method="POST">
                        @csrf
                        <div class="account-logo">
                            <a class="site-logo sidebar-main-logo site-title" href="{{ setRoute('index') }}">
                                <img src="{{ get_logo($basic_settings) }}"  data-white_img="{{ get_logo($basic_settings,'white') }}"
                                data-dark_img="{{ get_logo($basic_settings,'dark') }}"
                                    alt="site-logo">
                            </a>
                        </div>
                        <div class="form-header">
                            <h3 class="title"> {{ __($auth_data->value->language->$lang->forget_title ?? $auth_data->value->language->$system_default->forget_title ?? "") }}</h3>
                            <p>{{ __($auth_data->value->language->$lang->forget_sub_title ?? $auth_data->value->language->$system_default->forget_sub_title ?? "") }}</p>
                        </div>
                        <div class="form-input-fild">
                            <div class="row mb-10-none">
                                <div class="form-group col-lg-12 mb-10">
                                    @include('admin.components.form.input',[
                                        'name'          => "user",
                                        'placeholder'   => __("enter Email Address"),
                                        'required'      => true,
                                        'label'         =>__("Email Address")
                                    ])
                                </div>
                            </div>

                            <div class="account-btn pt-20">
                                <x-security.google-recaptcha-field />
                                <button type="submit" class="btn--base btn w-100 btn-loading">{{ __("Send OTP") }}</button>
                            </div>
                            <div class="footer-text">
                                <p class="d-block text-center mt-3 create-acc">
                                    &mdash; {{ __("Already Have An Account?") }}
                                    <a href="{{ setRoute('user.login') }}" class="text--base">{{ __("Sign In") }}</a>
                                    &mdash;
                                </p>
                                <p class="d-block text-center mt-3 create-acc">
                                    &mdash; {{ __("Back To") }}
                                    <a href="{{ setRoute('index') }}" class="text--base">{{ __("Home") }}</a>
                                    &mdash;
                                </p>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
@endsection

@push('script')

@endpush
