<?php
    $lang           = selectedLang();
    $system_default = $default_language_code;
    $auth_slug      = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::AUTH_SECTION);
    $auth_data      = App\Models\Admin\SiteSections::getData( $auth_slug)->first();

?>

<?php $__env->startSection('content'); ?>
   <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Start Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->


<section class="account-section ptb-60">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-xl-5 col-lg-6 col-md-9">
                <div class="account-login-form">
                    <form action="<?php echo e(setRoute('user.login.submit')); ?>" method="POST">
                        <?php echo csrf_field(); ?>
                        <div class="account-logo">
                            <a class="site-logo sidebar-main-logo site-title" href="<?php echo e(setRoute('index')); ?>">
                                <img src="<?php echo e(get_logo($basic_settings)); ?>"  data-white_img="<?php echo e(get_logo($basic_settings,'white')); ?>"
                                data-dark_img="<?php echo e(get_logo($basic_settings,'dark')); ?>"
                                    alt="site-logo">
                            </a>
                        </div>
                        <div class="form-header">
                            <h3 class="title"> <?php echo e(__($auth_data->value->language->$lang->login_title ?? $auth_data->value->language->$system_default->login_title ?? "")); ?></h3>
                            <p><?php echo e(__($auth_data->value->language->$lang->login_sub_title ?? $auth_data->value->language->$system_default->login_sub_title ?? "")); ?></p>
                        </div>
                        <div class="form-input-fild">
                            <div class="row mb-10-none">
                                <div class="form-group col-lg-12 mb-10">
                                    <?php echo $__env->make('admin.components.form.input',[
                                        'name'          => "credentials",
                                        'placeholder'   => __("Username OR Email Address"),
                                        'required'      => true,
                                        'label'         =>__("Email Address")
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                </div>
                                <div class="form-group show_hide_password col-lg-12 mb-10">
                                    <label><?php echo e(__("password")); ?> <span class="text--base">*</span></label>
                                    <input type="password" class="form-control form--control" name="password" placeholder="<?php echo e(__("Enter Password")); ?>">
                                    <a href="javascript:void(0)" class="show-pass icon field-icon"><i
                                            class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                </div>
                            </div>
                            <div class="forgot-item text-end pt-2">
                                <label><a href="<?php echo e(setRoute('user.password.forgot')); ?>" class="text--base"><?php echo e(__("forgot Password")); ?>?</a></label>
                            </div>
                            <div class="account-btn">
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
                                <button type="submit" class="btn--base w-100 btn-loading"><?php echo e(__("Log In")); ?></button>
                            </div>
                            <div class="footer-text">
                                <p class="d-block text-center mt-3 create-acc">
                                    &mdash; <?php echo e(__("have Account")); ?>

                                    <a href="<?php echo e(setRoute('user.register')); ?>" class="text--base"><?php echo e(__("Sign Up")); ?></a>
                                    &mdash;
                                </p>
                                <p class="d-block text-center mt-3 create-acc">
                                    &mdash; <?php echo e(__("Back To")); ?>

                                    <a href="<?php echo e(setRoute('index')); ?>" class="text--base"><?php echo e(__("Home")); ?></a>
                                    &mdash;
                                </p>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    End Account
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>

<?php $__env->stopPush(); ?>

<?php echo $__env->make('frontend.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/auth/login.blade.php ENDPATH**/ ?>