<?php
    $lang               = selectedLang();
    $system_default     = $default_language_code;
    $choose_us_slug     = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::CHOOSE_US_SECTION);
    $choose_us          = App\Models\Admin\SiteSections::getData( $choose_us_slug)->first();
?>

<section class="why-choice-us ptb-60">
    <div class="container">
        <div class="row">
            <div class="col-lg-7 col-md-10">
                <div class="section-tag ">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        <?php echo e(__($choose_us->value->language->$lang->heading ?? $choose_us->value->language->$system_default->heading ?? '')); ?>

                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title"><?php echo e(__($choose_us->value->language->$lang->sub_heading ?? $choose_us->value->language->$system_default->sub_heading ?? '')); ?></h2>
                    <p class="sub-title"><?php echo e(__($choose_us->value->language->$lang->details ?? $choose_us->value->language->$system_default->details ?? '')); ?></p>
                </div>
            </div>
        </div>
        <div class="choice-wrapper">

            <?php
                $items = array_values((array) $choose_us->value->items ?? []);
            ?>

            <div class="choice-wrapper">
                <?php $__currentLoopData = $items; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $index => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <?php if($index % 2 == 0): ?>
                        <div class="choice-card choice-card-<?php echo e(intval($index/2) + 1); ?>">
                    <?php endif; ?>

                    <div class="card-details-<?php echo e(($index % 2 == 0) ? '1' : '2'); ?> card-content" data-aos="<?php echo e(($index % 2 == 0) ? 'fade-right' : 'fade-left'); ?>" data-aos-duration="1200">
                        <h3 class="title"><?php echo e($item->language->$lang->title ?? $item->language->$system_default->title ?? ''); ?></h3>
                        <p><?php echo e($item->language->$lang->sub_title ?? $item->language->$system_default->sub_title ?? ''); ?></p>
                    </div>

                    <?php if($index % 2 != 0 || $loop->last): ?>
                        </div>
                    <?php endif; ?>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </div>
        </div>
    </div>
</section>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/sections/choose-us-section.blade.php ENDPATH**/ ?>