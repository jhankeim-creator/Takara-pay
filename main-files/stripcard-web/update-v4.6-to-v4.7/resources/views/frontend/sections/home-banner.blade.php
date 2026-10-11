@php
    $lang               = selectedLang();
    $system_default     = $default_language_code;
    $banner_slug        = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::HOME_BANNER);
    $banner             = App\Models\Admin\SiteSections::getData( $banner_slug)->first();
@endphp

<section class="banner-section" id="home">
    <div class="banner-element">
        <div class="banner-element-one">
        </div>
        <div class="banner-element-two">
        </div>
    </div>
    <div class="container">
        <div class="row align-items-center mb-30-none">
            <div class="col-xl-6 col-lg-6 mb-30">
                <div class="banner-content">
                    @php
                        $heading = explode(' ', $banner->value->language->$lang->heading ?? $banner->value->language->$system_default->heading);
                    @endphp

                    <span class="title-badge"></span>
                    <h5 class="sub-title"><span>{{ __("Welcome To") }} {{ $basic_settings->site_name }} !</span></h5>
                    <h1 class="title">{{ @$heading[0] }} {{ @$heading[1] }} {{ @$heading[2] }} {{ @$heading[4] }}  <span class="text--base"> {{ @$heading[5] }}  {{ @$heading[6] }}</span>  {{ @$heading[7] }}</h1>
                    <p>{{ __($banner->value->language->$lang->sub_heading ?? $banner->value->language->$system_default->sub_heading) }}</p>

                    <div class="banner-btn">
                        <a href="{{ setRoute('user.dashboard') }}" class="btn--base">{{ __("Apply Virtual Card") }}</a>
                    </div>
                </div>
            </div>
            <div class="col-xl-6 col-lg-6 mb-30">
                <div class="banner-thumb">
                    <img src="{{ get_image(@$banner->value->images->banner_image,'site-section') }}" alt="element">
                </div>
            </div>
        </div>
    </div>
</section>
