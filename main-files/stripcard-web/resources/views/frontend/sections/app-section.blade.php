@php
    $lang = selectedLang();
    $system_default = $default_language_code;
    $app_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::APP_SECTION);
    $app_sections = App\Models\Admin\SiteSections::getData($app_slug)->first();
    $app_links = App\Models\Admin\AppSettings::first(['android_url', 'iso_url']);
@endphp

<section class="app-section ptb-60">
    <div class="container">
        <div class="row flex-row-reverse mb-40-none">
            <div class="col-lg-6 col-md-12 mb-40">
                <div class="section-tag">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        {{ __($app_sections->value->language->$lang->title ?? $app_sections->value->language->$system_default->title) }}
                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">
                        {{ __($app_sections->value->language->$lang->heading ?? $app_sections->value->language->$system_default->heading) }}
                    </h2>
                    <p>{{ __($app_sections->value->language->$lang->sub_heading ?? $app_sections->value->language->$system_default->sub_heading) }}
                    </p>
                    <p>{{ __($app_sections->value->language->$lang->details ?? $app_sections->value->language->$system_default->details) }}
                    </p>
                </div>
                <div class="app-btn-wrapper">
                    <a href="{{ $app_links->android_url }}" class="app-btn" target="_blank">
                        <div class="app-icon">
                            <i class="lab la-google-play"></i>
                        </div>
                        <div class="content">
                            <span>{{ __('Get It On') }}</span>
                            <h5 class="title">{{ __('Google Play') }}</h5>
                        </div>
                        <div class="icon">
                            <img src="{{ get_image('frontend/images/element/qr-icon.png') }}" alt="element">
                        </div>
                        <div class="app-qr">
                            <img src="{{ generateQr($app_links->android_url ?? '') }}" alt="element">
                        </div>
                    </a>
                    <a href="{{ $app_links->iso_url }}" class="app-btn" target="_blank">
                        <div class="app-icon">
                            <i class="lab la-app-store"></i>
                        </div>
                        <div class="content">
                            <span>{{ __('Download On The') }}</span>
                            <h5 class="title">{{ __('Apple Store') }}</h5>
                        </div>
                        <div class="icon">
                            <img src="{{ get_image('frontend/images/element/qr-icon.png') }}" alt="element">
                        </div>
                        <div class="app-qr">
                            <img src="{{ generateQr($app_links->iso_url ?? '') }}" alt="element">
                        </div>
                    </a>
                </div>
            </div>
            <div class="col-lg-6 col-md-12 mb-40">
                <div class="app-img">
                    <img src="{{ get_image(@$app_sections->value->images->image, 'site-section') }}" alt="img">
                </div>
            </div>
        </div>
    </div>
</section>
