
@php
    $lang = selectedLang();
    $system_default  = $default_language_code;
    $testimonial_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::TESTIMONIAL_SECTION);
    $testimonial = App\Models\Admin\SiteSections::getData( $testimonial_slug)->first();
    $testimonial_items = (array)@$testimonial->value->items;
    $totalTestimonial = count(@$testimonial_items);

@endphp

<section class="testimonial-section ptb-60">
    <div class="container">
      <div class="row justify-content-center">
          <div class="col-lg-8 col-md-12">
              <div class="section-tag text-center ">
                  <h5 class="tag-line">
                      <span></span>
                      <span></span>
                      {{ __($testimonial->value->language->$lang->title ?? $testimonial->value->language->$system_default->title ?? "") }}
                      <span></span>
                      <span></span>
                  </h5>
                  <h2 class="section-title">{{ __($testimonial->value->language->$lang->sub_heading ?? $testimonial->value->language->$system_default->sub_heading ?? "") }}</h2>
                  <p class="sub-title"> {{ __($testimonial->value->language->$lang->details ?? $testimonial->value->language->$system_default->details ?? "We are at the forefront of revolutionizing the way people navigate the digital financial landscape. Our mission is clear: to provide users and entrepreneurs with a secure, efficient, and user-friendly platform for conducting online
                      transactions through virtual credit cards.") }}
                  </p>
              </div>
          </div>
      </div>
      <div class="testi-wrap">
        @php
            $index = 0;
        @endphp
        @if(isset($testimonial->value->items))
            @foreach($testimonial->value->items ?? [] as $key => $item)
            @php
                $index = $index+1;
            @endphp

                <div class="client-single {{ $index == 1 ? 'active' : 'inactive' }} position-{{ $index }}" data-position="position-{{ $index }}">
                    <div class="client-img">
                        <img src="{{ get_image(@$item->image ,'site-section') }}" alt="">
                    </div>
                    <div class="client-comment">
                        <p>{{ __($item->language->$lang->details ?? $item->language->$system_default->details )}}</p>
                        <span><i class="fa fa-quote-left"></i></span>
                    </div>
                    <div class="client-info">
                        <h3>{{ __($item->language->$lang->name ?? $item->language->$system_default->name )}}</h3>
                        <p>{{ __($item->language->$lang->designation ?? $item->language->$system_default->designation )}}</p>
                    </div>
                </div>
            @endforeach
          @endif
      </div>
    </div>
</section>

@push('script')
<script>
    $(document).ready(function () {
          function switchTestimonial() {
              var parent = $('.testi-wrap');
              var activeBlock = parent.find('.client-single.active');
              var nextBlock = activeBlock.next('.client-single');

              if (nextBlock.length === 0) {
                  nextBlock = parent.find('.client-single').first();
              }

              var currentPos = activeBlock.attr('data-position');
              var newPos = nextBlock.attr('data-position');

              activeBlock.removeClass('active').removeClass(currentPos).addClass('inactive').addClass(newPos);
              activeBlock.attr('data-position', newPos);

              nextBlock.addClass('active').removeClass('inactive').removeClass(newPos).addClass(currentPos);
              nextBlock.attr('data-position', currentPos);
          }

          setInterval(switchTestimonial, 3000); // Change every 3 seconds
      });

</script>
@endpush
