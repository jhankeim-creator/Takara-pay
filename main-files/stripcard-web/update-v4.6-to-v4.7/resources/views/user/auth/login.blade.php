
@extends('frontend.layouts.master')

@php
    $lang           = selectedLang();
    $system_default = $default_language_code;
    $auth_slug      = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::AUTH_SECTION);
    $auth_data      = App\Models\Admin\SiteSections::getData( $auth_slug)->first();

@endphp

@section('content')
   <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Start Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->


<section class="account-section ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-9">
                <div class="account-login-form">
                    <form action="{{ setRoute('user.login.submit') }}" method="POST">
                        @csrf
                        <div class="account-logo">
                            <a class="site-logo sidebar-main-logo site-title" href="{{ setRoute('index') }}">
                                <img src="{{ get_logo($basic_settings) }}"  data-white_img="{{ get_logo($basic_settings,'white') }}"
                                data-dark_img="{{ get_logo($basic_settings,'dark') }}"
                                    alt="site-logo">
                            </a>
                        </div>
                        <div class="form-header">
                            <h3 class="title"> {{ __($auth_data->value->language->$lang->login_title ?? $auth_data->value->language->$system_default->login_title ?? "") }}</h3>
                            <p>{{ __($auth_data->value->language->$lang->login_sub_title ?? $auth_data->value->language->$system_default->login_sub_title ?? "") }}</p>
                        </div>
                        <div class="form-input-fild">
                            <div class="row mb-10-none">
                                <div class="form-group col-lg-12 mb-10">
                                    @include('admin.components.form.input',[
                                        'name'          => "credentials",
                                        'placeholder'   => __("Username OR Email Address"),
                                        'required'      => true,
                                        'label'         =>__("Email Address")
                                    ])
                                </div>
                                <div class="form-group show_hide_password col-lg-12 mb-10">
                                    <label>{{ __("password") }} <span class="text--base">*</span></label>
                                    <input type="password" class="form-control form--control" name="password" placeholder="{{ __("Enter Password") }}">
                                    <a href="javascript:void(0)" class="show-pass icon field-icon"><i
                                            class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                            </div>
                            <div class="forgot-item text-end pt-2">
                                <label><a href="{{ setRoute('user.password.forgot') }}" class="text--base">{{ __("forgot Password") }}?</a></label>
                            </div>
                            <div class="account-btn">
                                <x-security.google-recaptcha-field />
                                <button type="submit" class="btn--base w-100 btn-loading">{{ __("Log In") }}</button>
                            </div>
                            <div class="footer-text">
                                <p class="d-block text-center mt-3 create-acc">
                                    &mdash; {{ __("have Account") }}
                                    <a href="{{ setRoute('user.register') }}" class="text--base">{{ __("Sign Up") }}</a>
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

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    End Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
@endsection

@push('script')

@endpush
