<?php
    $lang = selectedLang();
    $system_default = $default_language_code;
    $footer_slug = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::FOOTER_SECTION);
    $footer = App\Models\Admin\SiteSections::getData($footer_slug)->first();
    $type = Illuminate\Support\Str::slug(App\Constants\GlobalConst::USEFUL_LINKS);
    $policies = App\Models\Admin\SetupPage::orderBy('id')->where('type', $type)->where('status', 1)->get();

?>

<footer class="footer-section bg-overlay-banner bg_img"
    data-background="<?php echo e(get_image('frontend/images/element/bg-img.webp')); ?>" id="animated-section">
    <div class="container mx-auto">
        <div class="footer-content pt-60">
            <div class="row">
                <div class="col-xl-4 col-lg-4 mb-50">
                    <div class="footer-widget">
                        <div class="footer-text">
                            <a class="site-logo sidebar-main-logo site-title" href="<?php echo e(setRoute('index')); ?>">
                                <img src="<?php echo e(get_logo($basic_settings)); ?>"
                                    data-white_img="<?php echo e(get_logo($basic_settings, 'white')); ?>"
                                    data-dark_img="<?php echo e(get_logo($basic_settings, 'dark')); ?>" alt="site-logo">
                            </a>
                            <P><?php echo e(__($footer->value->language->$lang->details ?? $footer->value->language->$system_default->details)); ?>

                            </P>
                        </div>
                        <div class="footer-social-icon">
                            <span><?php echo e(__('Follow Us')); ?> :</span>
                            <?php if(isset($footer->value->items)): ?>
                                <?php $__currentLoopData = $footer->value->items ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <a href="<?php echo e($item->language->$lang->link ?? $item->language->$system_default->link); ?>"
                                        target="_blank"><i
                                            class="<?php echo e($item->language->$lang->social_icon ?? $item->language->$system_default->social_icon); ?>"></i></a>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            <?php endif; ?>

                        </div>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 mb-30">
                    <div class="footer-widget">
                        <div class="footer-widget-heading">
                            <h3><?php echo e(__('Useful Links')); ?></h3>
                        </div>
                        <ul>
                            <?php $__currentLoopData = $policies ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $data): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <li><a
                                        href="<?php echo e(setRoute('useful.link', $data->slug)); ?>"><?php echo e($data->title->language->$lang->title ?? $data->title->language->$system_default->title); ?></a>
                                </li>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </ul>
                    </div>
                </div>
                <div class="col-xl-4 col-lg-4 col-md-6 mb-50">
                    <div class="footer-widget">
                        <div class="footer-widget-heading">
                            <h3><?php echo e(__('Subscribe')); ?></h3>
                        </div>
                        <div class="footer-text mb-25">
                            <p><?php echo e(__($footer->value->language->$lang->subscribe_sub_title ?? ($footer->value->language->$system_default->subscribe_sub_title ?? __('Stay Connected! Subscribe to Our Latest Feeds – Just Fill Out the Form Below.')))); ?>

                            </p>
                        </div>
                        <form action="<?php echo e(setRoute('subscribe.submit')); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <div class="subscribe-form">
                                <input type="email" name="email" class="form--control"
                                    placeholder="<?php echo e(__('enter Email Address')); ?>">
                                <button class="display:block"><i class="fab fa-telegram-plane"></i></button>
                            </div>
                            <div class="pt-20">
                                <?php if (isset($component)) { $__componentOriginal6c05d6dc89e45801aa68104ade06338b = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal6c05d6dc89e45801aa68104ade06338b = $attributes; } ?>
<?php $component = App\View\Components\Security\GoogleRecaptchaField::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('security.google-recaptcha-field'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Security\GoogleRecaptchaField::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal6c05d6dc89e45801aa68104ade06338b)): ?>
<?php $attributes = $__attributesOriginal6c05d6dc89e45801aa68104ade06338b; ?>
<?php unset($__attributesOriginal6c05d6dc89e45801aa68104ade06338b); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal6c05d6dc89e45801aa68104ade06338b)): ?>
<?php $component = $__componentOriginal6c05d6dc89e45801aa68104ade06338b; ?>
<?php unset($__componentOriginal6c05d6dc89e45801aa68104ade06338b); ?>
<?php endif; ?>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="copyright-area">
        <div class="container">
            <div class="row">
                <div class="col-12 text-center text-lg-left">
                    <div class="copyright-text">
                        <p>&copy; <?php echo e(date('Y')); ?>, <?php echo e(__('All Rights Reserved')); ?>. <a class="fw-bold"
                                href="<?php echo e(setRoute('index')); ?>"><span><?php echo e($basic_settings->site_name); ?></span></a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</footer>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/partials/footer.blade.php ENDPATH**/ ?>