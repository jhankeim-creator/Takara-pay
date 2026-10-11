<?php
    $app_mode = strtolower(config('app.mode'));
?>
<?php $__env->startSection('section'); ?>
    <div class="account-wrapper">
        <div class="account-header">
            <div class="site-logo">
                <img src="<?php echo e(get_logo($basic_settings)); ?>" alt="logo">
            </div>
            <h6 class="sub-title"><?php echo e(__("Welcome To")); ?> <span><?php echo e(__("Admin Panel")); ?></span></h6>
        </div>
        <form class="account-form" action="<?php echo e(setRoute('admin.login.submit')); ?>" method="POST">
            <?php echo csrf_field(); ?>
            <div class="form-group">
                <input type="text" class="<?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" title="Enter Username" required name="email" value="<?php echo e(old('email')); ?>" autofocus>
                <label><?php echo e(__("Email Address")); ?></label>

                <?php $__errorArgs = ['email'];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                    <div class="alert alert-danger"><?php echo e($message); ?></div>
                <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
            </div>
            <div class="form-group show_hide_password">
                <input type="password" title="Enter password" required name="password" value="">
                <button type="button" class="show-pass"><i class="fa fa-eye-slash" aria-hidden="true"></i></button>
                <label><?php echo e(__("Password")); ?></label>
            </div>
            <div class="form-group">
                <div class="forgot-item">
                    <p><a href="<?php echo e(setRoute('admin.password.forgot')); ?>" class="text--base"><?php echo e(__("forget Password")); ?><?php echo e("?"); ?></a></p>
                </div>
            </div>
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
            <button type="submit" class="btn--base w-100 btn-loading"><?php echo e(__("Login")); ?></button>
        </form>
    </div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('admin.auth.layouts.auth-master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/auth/login.blade.php ENDPATH**/ ?>