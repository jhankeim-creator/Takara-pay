<?php $__env->startPush('css'); ?>
    <style>
        .fileholder {
            min-height: 280px !important;
        }

        .fileholder-files-view-wrp.accept-single-file .fileholder-single-file-view,.fileholder-files-view-wrp.fileholder-perview-single .fileholder-single-file-view{
            height: 246px !important;
        }
    </style>
<?php $__env->stopPush(); ?>

<?php $__env->startSection('page-title'); ?>
    <?php echo $__env->make('admin.components.page-title',['title' => __($page_title)], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('breadcrumb'); ?>
    <?php echo $__env->make('admin.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("admin.dashboard"),
        ]
    ], 'active' => __($page_title)], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title"><?php echo e(__($page_title)); ?></h6>
        </div>
        <div class="card-body">
            <form class="card-form" method="POST" enctype="multipart/form-data" action="<?php echo e(setRoute('admin.users.store')); ?>">
                <?php echo csrf_field(); ?>
                <div class="row mb-10-none">
                    <div class="col-xl-6 col-lg-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         => __("First Name")."*",
                            'name'          => "firstname",
                            'placeholder'   => __("enter First Name"),
                            'value'         => old("firstname"),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                    <div class="col-xl-6 col-lg-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         =>__("Last Name")."*",
                            'name'          => "lastname",
                            'placeholder'   => __("enter Last Name"),
                            'value'         => old("lastname"),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                    <div class="col-xl-6 col-lg-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         =>__("Email")."*",
                            'name'          => "email",
                            'placeholder'   =>__("Enter Email"),
                            'value'         => old("email"),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>

                    <div class="col-xl-6 col-lg-6 form-group">
                        <label><?php echo e(__("Password")); ?>*</label>
                        <div class="input-group">
                            <input type="text" class="form--control place_random_password <?php $__errorArgs = ["password"];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" placeholder="<?php echo e(__('Enter Password')); ?>" name="password">
                            <button class="input-group-text rand_password_generator" type="button"><?php echo e(__("Generate")); ?></button>
                        </div>
                        <?php $__errorArgs = ["password"];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?>
                            <span class="invalid-feedback d-block" role="alert">
                                <strong><?php echo e($message); ?></strong>
                            </span>
                        <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>
                    </div>

                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.switcher', [
                            'label'         => __("Email Verification"),
                            'value'         => old('email_verified',1),
                            'name'          => "email_verified",
                            'options'       => [__("verified") => 1, __("Unverified") => 0],
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                    <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.switcher', [
                            'label'         => __("KYC Verification"),
                            'value'         => old('kyc_verified',1),
                            'name'          => "kyc_verified",
                            'options'       => [__("verified") => 1, __("Unverified") => 0],
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group">
                        <button type="submit" class="btn--base w-100 btn-loading"><?php echo e(__("Add")); ?></button>
                    </div>
                </div>
            </form>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush("script"); ?>
    <script>
        function placeRandomPassword(clickedButton,placeInput) {
            $(clickedButton).click(function(){
                var generateRandomPassword = makeRandomString(10);
                $(placeInput).val(generateRandomPassword);
            });
        }
        placeRandomPassword(".rand_password_generator",".place_random_password");
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('admin.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/sections/user-care/create.blade.php ENDPATH**/ ?>