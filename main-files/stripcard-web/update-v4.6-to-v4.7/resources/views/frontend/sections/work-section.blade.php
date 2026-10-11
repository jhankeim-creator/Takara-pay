@php
    $lang = selectedLang();
    $system_default = $default_language_code;
    $work_slug      = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::WORK_SECTION);
    $work           = App\Models\Admin\SiteSections::getData( $work_slug)->first();
@endphp

<section class="how-work-section ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-9 col-lg-10">
                <div class="section-tag text-center">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        {{ __($work->value->language->$lang->title ?? $work->value->language->$system_default->title ?? '') }}
                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">{{ __($work->value->language->$lang->sub_title ?? $work->value->language->$system_default->sub_title ?? '') }}</h2>
                    <p class="sub-title">{{ __($work->value->language->$lang->details ?? $work->value->language->$system_default->details ?? 'Discover how TAKARA PAY empowers you with an easy step-by-step process to manage virtual cards, add funds, transfer money, and ensure secure transactions—all designed for convenience, flexibility, and seamless financial management.') }}</p>
                </div>
            </div>
        </div>
        <div class="how-work-area">
            <div class="row mb-20-none">
                @php
                    $items = (array) $work->value->items ?? [];
                    $firstRow = [];
                    $secondRow = [];

                    $index = 0; // Manual Index Counter

                    foreach ($items as $key => $item) {
                        if ($index % 2 == 0) {
                            $firstRow[$key] = $item; // Push to First Row
                        } else {
                            $secondRow[$key] = $item; // Push to Second Row
                        }
                        $index++;
                    }
                @endphp
                <div class="col-lg-6 mb-20">
                    <div class="row mb-20-none">
                        @foreach($firstRow as $item)
                            <div class="col-lg-12 mb-20" data-aos="fade-right" data-aos-duration="1200">
                                <div class="how-work-item">
                                    <div class="how-work-icon">
                                        <i class="{{ $item->language->$lang->icon ?? $item->language->$system_default->icon }}"></i>
                                    </div>
                                    <div class="how-work-content">
                                        <h3 class="title">{{ $item->language->$lang->name ?? $item->language->$system_default->name }}</h3>
                                        <p>{{ $item->language->$lang->details ?? $item->language->$system_default->details }}</p>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>

                <div class="col-lg-6 mb-20">
                    <div class="row">
                        @foreach($secondRow as $item)
                            <div class="col-xl-12 mb-20" data-aos="fade-left" data-aos-duration="1200">
                                <div class="how-work-item">
                                    <div class="how-work-icon">
                                        <i class="{{ $item->language->$lang->icon ?? $item->language->$system_default->icon }}"></i>
                                    </div>
                                    <div class="how-work-content">
                                        <h3 class="title">{{ $item->language->$lang->name ?? $item->language->$system_default->name }}</h3>
                                        <p>{{ $item->language->$lang->details ?? $item->language->$system_default->details }}</p>
                                    </div>
                                </div>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
