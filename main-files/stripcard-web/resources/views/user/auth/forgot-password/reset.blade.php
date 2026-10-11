@extends('frontend.layouts.master')

@section('content')
<section class="account-section new-password ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-9">
                <div class="account-login-form">
                    <form action="{{ setRoute('user.password.reset',$token) }}" class="account-form" method="POST">
                        @csrf
                        <div class="account-logo">
                            <a class="site-logo sidebar-main-logo site-title" href="{{ setRoute('index') }}">
                                <img src="{{ get_logo($basic_settings) }}"  data-white_img="{{ get_logo($basic_settings,'white') }}"
                                data-dark_img="{{ get_logo($basic_settings,'dark') }}"
                                    alt="site-logo">
                            </a>
                        </div>

                        <div class="form-input-fild">
                            <div class="row mb-10-none">
                                <label>{{ __("new Password") }}</label>
                                <div class="col-lg-12 form-group show_hide_password">
                                    <input type="password" required name="password" class="form-control form--control"  placeholder="{{__("Enter Password")}}">
                                    <a href="javascript:void(0)" class="show-pass"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                                <label>{{ __("confirm Password") }}</label>
                                <div class="col-lg-12 form-group show_hide_password-2">
                                    <input type="password" required name="password_confirmation" class="form-control form--control"  placeholder="{{ __("Enter Confirm Password") }}">
                                    <a href="javascript:void(0)" class="show-pass"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                                <div class="col-lg-12 form-group text-center pt-3">
                                    <button type="submit" class="btn--base w-100 btn-loading">{{ __("Reset") }}</button>
                                </div>
                            </div>

                            <div class="footer-text">
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
