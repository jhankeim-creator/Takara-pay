@php
    $lang = selectedLang();
    $system_default = $default_language_code;
    $footer_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::FOOTER_SECTION);
    $footer = App\Models\Admin\SiteSections::getData($footer_slug)->first();
    $type = Illuminate\Support\Str::slug(App\Constants\GlobalConst::USEFUL_LINKS);
    $policies = App\Models\Admin\SetupPage::orderBy('id')->where('type', $type)->where('status', 1)->get();

@endphp

<footer class="footer-section bg-overlay-banner bg_img"
    data-background="{{ get_image('frontend/images/element/bg-img.webp') }}" id="animated-section">
    <div class="container mx-auto">
        <div class="footer-content pt-60">
            <div class="row">
                <div class="col-xl-4 col-lg-4 mb-50">
                    <div class="footer-widget">
                        <div class="footer-text">
                            <a class="site-logo sidebar-main-logo site-title" href="{{ setRoute('index') }}">
                                <img src="{{ get_logo($basic_settings) }}"
                                    data-white_img="{{ get_logo($basic_settings, 'white') }}"
                                    data-dark_img="{{ get_logo($basic_settings, 'dark') }}" alt="site-logo">
                            </a>
                            <P>{{ __($footer->value->language->$lang->details ?? $footer->value->language->$system_default->details) }}
                            </P>
                        </div>
                        <div class="footer-social-icon">
                            <span>{{ __('Follow Us') }} :</span>
                            @if (isset($footer->value->items))
                                @foreach ($footer->value->items ?? [] as $key => $item)
                                    <a href="{{ $item->language->$lang->link ?? $item->language->$system_default->link }}"
                                        target="_blank"><i
                                            class="{{ $item->language->$lang->social_icon ?? $item->language->$system_default->social_icon }}"></i></a>
                                @endforeach
                            @endif

                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 mb-30">
                    <div class="footer-widget">
                        <div class="footer-widget-heading">
                            <h3>{{ __('Useful Links') }}</h3>
                        </div>
                        <ul>
                            @foreach ($policies ?? [] as $key => $data)
                                <li><a
                                        href="{{ setRoute('useful.link', $data->slug) }}">{{ $data->title->language->$lang->title ?? $data->title->language->$system_default->title }}</a>
                                </li>
                            @endforeach
                        </ul>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 mb-50">
                    <div class="footer-widget">
                        <div class="footer-widget-heading">
                            <h3>{{ __('Subscribe') }}</h3>
                        </div>
                        <div class="footer-text mb-25">
                            <p>{{ __($footer->value->language->$lang->subscribe_sub_title ?? ($footer->value->language->$system_default->subscribe_sub_title ?? __('Stay Connected! Subscribe to Our Latest Feeds – Just Fill Out the Form Below.'))) }}
                            </p>
                        </div>
                        <form action="{{ setRoute('subscribe.submit') }}" method="POST">
                            @csrf
                            <div class="subscribe-form">
                                <input type="email" name="email" class="form--control"
                                    placeholder="{{ __('enter Email Address') }}">
                                <button class="display:block"><i class="fab fa-telegram-plane"></i></button>
                            </div>
                            <div class="pt-20">
                                <x-security.google-recaptcha-field />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="copyright-area">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center text-lg-left">
                    <div class="copyright-text">
                        <p>&copy; {{ date('Y') }}, {{ __('All Rights Reserved') }}. <a class="fw-bold"
                                href="{{ setRoute('index') }}"><span>{{ $basic_settings->site_name }}</span></a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
