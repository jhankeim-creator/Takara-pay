<?php $__env->startSection('content'); ?>
    <div class="doc-inner">
        <div class="doc-wrapper w-100">
            <h2 class="inner-title"><span><?php echo e(__("Welcome")); ?></span> <?php echo e(__("To Project Installation Process")); ?></h2>
            <h5 class="mt-10 text--white fw-normal"><?php echo e(__("To continue with the installation process click on the start button. if you choose not to install this application, click on the cancel button. Thanks")); ?></h5>
            <div class="doc-btn mt-20 d-flex align-items-center justify-content-center gap-3">
                <a href="<?php echo e(route('project.install.cancel')); ?>" class="btn--base bg-danger w-100"><?php echo e(__("Cancel")); ?></a>
                <a href="<?php echo e(route('project.install.requirements')); ?>" class="btn--base w-100"><?php echo e(__("Start")); ?> &nbsp; &nbsp; &#8921;</a>
            </div>
        </div>
    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('installer.layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/installer/src/views/installer/pages/welcome.blade.php ENDPATH**/ ?>