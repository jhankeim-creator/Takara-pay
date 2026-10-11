<?php
    $lang = selectedLang();
    $system_default = $default_language_code;
    $statistics_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::STATISTICS_SECTION);
    $statistics = App\Models\Admin\SiteSections::getData($statistics_slug)->first();
?>
<section class="overview-section ptb-60">
    <div class="container">
        <div class="row mb-40-none">
            <div class="col-xl-6 col-lg-6 mb-60">
                <div class="section-tag ">
                    <h5 class="tag-line">
                        <span></span>
                        <span></span>
                        <?php echo e(__($statistics->value->language->$lang->title ?? ($statistics->value->language->$system_default->title ?? 'Project Overview'))); ?>

                        <span></span>
                        <span></span>
                    </h5>
                    <h2 class="section-title">
                        <?php echo e(__($statistics->value->language->$lang->sub_title ?? ($statistics->value->language->$system_default->sub_title ?? 'Project Highlights at a Glance'))); ?>

                    </h2>
                    <p class="sub-title">
                        <?php echo e(__(
                            $statistics->value->language->$lang->details ??
                                ($statistics->value->language->$system_default->details ??
                                    "Explore key milestones and achievements of our project, brought to life with real-time counters showcasing our growth,
                                                                    success, and impact. See how we're delivering results and making a difference through our innovative solutions."),
                        )); ?>

                    </p>
                </div>
                <div class="overview-details  mb-20-none">
                    <div class="overview-item counter mb-20">
                        <p><span class="odometer"
                                data-odometer-final="<?php echo e($statistics->value->language->$lang->total_users ?? (@$statistics->value->language->$system_default->total_users ?? 0)); ?>">0</span><?php echo e(__('Total Users')); ?>

                        </p>
                    </div>
                    <div class="overview-item mb-20">
                        <p><span class="odometer"
                                data-odometer-final="<?php echo e($statistics->value->language->$lang->happy_users ?? (@$statistics->value->language->$system_default->happy_users ?? 0)); ?>">0</span><?php echo e(__('Happy Users')); ?>

                        </p>
                    </div>
                    <div class="overview-item mb-20">
                        <p><span class="odometer"
                                data-odometer-final="<?php echo e($statistics->value->language->$lang->total_service ?? (@$statistics->value->language->$system_default->total_service ?? 0)); ?>">0</span><?php echo e(__('Services')); ?>

                        </p>
                    </div>
                </div>
            </div>
            <div class="col-xl-6 col-lg-6 mb-40">

                <div class="overview-img">
                    <?php if(isset($statistics->value->images->image)): ?>
                        <img src="<?php echo e(get_image(@$statistics->value->images->image, 'site-section')); ?>" alt="img">
                    <?php else: ?>
                        <img src="<?php echo e(get_image('frontend/images/element/overview-img.webp')); ?>" alt="img">
                    <?php endif; ?>

                    <div class="overview-element">
                        <h5 class="title">
                            <?php echo e(__($statistics->value->language->$lang->transaction_title ?? ($statistics->value->language->$system_default->transaction_title ?? 'Transactions Processed'))); ?>

                        </h5>
                        <p class="description" id="transaction-description">
                            <?php echo e(__($statistics->value->language->$lang->transaction_details ?? ($statistics->value->language->$system_default->transaction_details ?? "Over $10M in transactions processed securely, ensuring smooth financial operations for our users."))); ?>

                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/sections/statistics-section.blade.php ENDPATH**/ ?>