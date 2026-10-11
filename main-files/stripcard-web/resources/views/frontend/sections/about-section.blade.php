
@php
    $lang           = selectedLang();
    $system_default = $default_language_code;
    $about_slug     = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::ABOUT_SECTION);
    $about_sections = App\Models\Admin\SiteSections::getData( $about_slug)->first();
@endphp

<section class="about-section ptb-60">
    <div class="container">
        <div class="row mb-30-none">
            <div class="col-lg-6 col-md-12 mb-30">
                <div class="section-tag ">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        {{ __($about_sections->value->language->$lang->section_title ?? $about_sections->value->language->$system_default->section_title) }}
                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">{{ __($about_sections->value->language->$lang->heading ?? $about_sections->value->language->$system_default->heading) }}</h2>
                    <p>{{ __($about_sections->value->language->$lang->sub_heading ?? $about_sections->value->language->$system_default->sub_heading) }}</p>
                    <div class="about-item pt-4">
                        <div class="row">
                            @if(isset($about_sections->value->items))
                                @foreach($about_sections->value->items ?? [] as $key => $item)
                                    <div class="col-lg-6">
                                        <div class="item d-flex">
                                            <div class="item-icon">
                                                <i class="{{ $item->language->$lang->icon ?? $item->language->$system_default->icon }}"></i>
                                            </div>
                                            <div class="item-name">
                                                <P>{{ __($item->language->$lang->title ?? $item->language->$system_default->title)}}</P>
                                            </div>
                                        </div>
                                    </div>
                                @endforeach
                            @endif
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 col-md-12 mb-30">
                <div class="about-section-img">
                    <img src="{{ get_image(@$about_sections->value->images->image,'site-section') }}" alt="img">
                </div>
            </div>
        </div>
    </div>
</section>
