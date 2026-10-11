<?php
    $lang = selectedLang();
    $system_default  = $default_language_code;
    $service_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::SERVICE_SECTION);
    $service = App\Models\Admin\SiteSections::getData( $service_slug)->first();

?>

<section class="core-service-section <?php echo e(Route::currentRouteName() == 'index' ? '' : 'service-page'); ?> ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-9 col-lg-10">
               <div class="section-tag text-center">
                   <h5 class="tag-line">
                       <span></span>
                       <span></span>
                       <?php echo e(__($service->value->language->$lang->heading ?? $service->value->language->$system_default->heading)); ?>

                       <span></span>
                       <span></span>
                   </h5>
                   <h2 class="section-title"><?php echo e(__($service->value->language->$lang->sub_heading ?? $service->value->language->$system_default->sub_heading)); ?></h2>
                   <p class="sub-title"><?php echo e(__($service->value->language->$lang->details ?? $service->value->language->$system_default->details ?? "Unlock seamless digital transactions with our powerful services, from virtual card management and secure payments to
                   multi-language support and real-time notifications—designed for convenience and security.")); ?></p>
               </div>
            </div>
        </div>
        <div class="core-service-area">
            <div class="row justify-content-center mb-20-none">
                <?php if(isset($service->value->items)): ?>
                    <?php $__currentLoopData = $service->value->items ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <div class="col-lg-3 col-md-6 col-sm-10 mb-20">
                        <div class="core-service-item">
                            <div class="service-icon">
                                <img src="<?php echo e(get_image(@$item->image ,'site-section')); ?>" alt="Card">
                            </div>
                            <div class="service-content">
                                <h3 class="title"><?php echo e(__($item->language->$lang->title ?? $item->language->$system_default->title )); ?></h3>
                                <p><?php echo e(__($item->language->$lang->sub_title ?? $item->language->$system_default->sub_title )); ?></p>
                            </div>
                        </div>
                        </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                <?php endif; ?>

            </div>
        </div>
    </div>
</section>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/sections/service-section.blade.php ENDPATH**/ ?>