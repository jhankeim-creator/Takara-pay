@php
    $lang               = selectedLang();
    $system_default     = $default_language_code;
    $choose_us_slug     = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::CHOOSE_US_SECTION);
    $choose_us          = App\Models\Admin\SiteSections::getData( $choose_us_slug)->first();
@endphp

<section class="why-choice-us ptb-60">
    <div class="container">
        <div class="row">
            <div class="col-lg-7 col-md-10">
                <div class="section-tag ">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        {{ __($choose_us->value->language->$lang->heading ?? $choose_us->value->language->$system_default->heading ?? '') }}
                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">{{ __($choose_us->value->language->$lang->sub_heading ?? $choose_us->value->language->$system_default->sub_heading ?? '') }}</h2>
                    <p class="sub-title">{{ __($choose_us->value->language->$lang->details ?? $choose_us->value->language->$system_default->details ?? '') }}</p>
                </div>
            </div>
        </div>
        <div class="choice-wrapper">

            @php
                $items = array_values((array) $choose_us->value->items ?? []);
            @endphp

            <div class="choice-wrapper">
                @foreach($items as $index => $item)
                    @if($index % 2 == 0)
                        <div class="choice-card choice-card-{{ intval($index/2) + 1 }}">
                    @endif

                    <div class="card-details-{{ ($index % 2 == 0) ? '1' : '2' }} card-content" data-aos="{{ ($index % 2 == 0) ? 'fade-right' : 'fade-left' }}" data-aos-duration="1200">
                        <h3 class="title">{{ $item->language->$lang->title ?? $item->language->$system_default->title ?? '' }}</h3>
                        <p>{{ $item->language->$lang->sub_title ?? $item->language->$system_default->sub_title ?? '' }}</p>
                    </div>

                    @if($index % 2 != 0 || $loop->last)
                        </div>
                    @endif
                @endforeach
            </div>
        </div>
    </div>
</section>
