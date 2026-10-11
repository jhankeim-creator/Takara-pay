@php
    $lang                   = selectedLang();
    $system_default         = $default_language_code;
    $faq_section_slug       = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::FAQ_SECTION);
    $faq_section            = App\Models\Admin\SiteSections::getData( $faq_section_slug)->first();
@endphp
<section class="faq-section ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 md-12">
                <div class="section-tag text-center">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        {{ __($faq_section->value->language->$lang->heading ?? $faq_section->value->language->$system_default->heading ?? '') }}
                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">{{ __($faq_section->value->language->$lang->sub_heading ?? $faq_section->value->language->$system_default->sub_heading ?? '') }}</h2>
                    <p class="sub-title">{{ __($faq_section->value->language->$lang->details ?? $faq_section->value->language->$system_default->details ?? "" )}}</p>
                </div>
            </div>
        </div>

        @php
            $items = (array) $faq_section->value->items ?? [];

                $itemData   = (array) $items;
                if ($itemData != []) {
                    $data = array_chunk($itemData, ceil(count($itemData) / 2));
                    $part1 = $data[0];
                    $part2 = $data[1];
                }
        @endphp
        <div class="row justify-content-center">
            <div class="col-xl-6 col-lg-6 mb-20">
                <div class="faq-wrapper">
                    @foreach ($part1 as $item)
                        <div class="faq-item">
                            <h3 class="faq-title"><span class="title">{{ __($item->language->$lang->question ?? $item->language->$system_default->question ?? "") }}</span><span class="right-icon"></span></h3>
                            <div class="faq-content">
                                <p>{{ __($item->language->$lang->answer ?? $item->language->$system_default->answer ?? "") }}</p>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
            <div class="col-xl-6 col-lg-6 mb-20">
                <div class="faq-wrapper">
                    @foreach ($part2 as $item)
                    <div class="faq-item">
                        <h3 class="faq-title"><span class="title">{{ __($item->language->$lang->question ?? $item->language->$system_default->question ?? "") }}</span><span class="right-icon"></span></h3>
                        <div class="faq-content">
                            <p>{{ __($item->language->$lang->answer ?? $item->language->$system_default->answer ?? "") }}</p>
                        </div>
                    </div>
                @endforeach
                </div>
            </div>
        </div>
    </div>
</section>
