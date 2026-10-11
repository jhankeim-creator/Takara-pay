<?php $__env->startPush('css'); ?>

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
    ], 'active' => __("Web Settings")], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title"><?php echo e(__("Basic Settings")); ?></h6>
        </div>
        <div class="card-body">
            <form class="card-form" method="POST" action="<?php echo e(setRoute('admin.web.settings.basic.settings.update')); ?>">
                <?php echo csrf_field(); ?>
                <?php echo method_field("PUT"); ?>
                <div class="row">
                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <label><?php echo e(__("Site Base Color")); ?>*</label>
                        <div class="picker">
                            <input type="color" value="<?php echo e(old('base_color',$basic_settings->base_color)); ?>" class="color color-picker">
                            <input type="text" autocomplete="off" spellcheck="false" class="color-input" value="<?php echo e(old('base_color',$basic_settings->base_color)); ?>" name="base_color">
                        </div>
                    </div>

                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         => __("Site Name")."*",
                            'type'          => "text",
                            'class'         => "form--control",
                            'name'          => "site_name",
                            'value'         => old('site_name',$basic_settings->site_name),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                     <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         => __("Site Title")."*",
                            'type'          => "text",
                            'class'         => "form--control",
                            'name'          => "site_title",
                            'value'         => old('site_title',$basic_settings->site_title),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>

                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         =>__( "Web Version")."*",
                            'type'          => "text",
                            'class'         => "form--control",
                            'placeholder'   => "Write Web Version...",
                            'name'          => "web_version",
                            'value'         => old('web_version',$basic_settings->web_version),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>


                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <label><?php echo e(__("OTP Expiration")); ?>*</label>
                        <div class="input-group">
                            <input type="number" class="form--control" value="<?php echo e(old('otp_exp_seconds',$basic_settings->otp_exp_seconds)); ?>" name="otp_exp_seconds">
                            <span class="input-group-text"><?php echo e(__("Seconds")); ?></span>
                        </div>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <label><?php echo e(__("Timezone")); ?>*</label>
                        <select name="timezone" class="form--control select2-auto-tokenize timezone-select" data-old="<?php echo e(old('timezone',$basic_settings->timezone)); ?>">
                            <option selected disabled><?php echo e(__("Select Timezone")); ?></option>
                        </select>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         => __("Admin Prefix").'*',
                            'type'          => "text",
                            'class'         => "form--control",
                            'placeholder'   => __("Write Name").'...',
                            'name'          => "admin_prefix",
                            'value'         => old('admin_prefix',$basic_settings->admin_prefix),
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        <span class="login-url"></span>
                    </div>
                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                        <label for="frontend_url"><?php echo e(__('Frontend URLS')); ?>*</label>
                        <select name="frontend_url[]" multiple id="frontend_url"
                            class="select2-auto-tokenize">
                            <?php $__currentLoopData = $basic_settings->frontend_url ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <option value="<?php echo e($item); ?>" selected><?php echo e($item); ?></option>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </select>
                    </div>
                    
                </div>
                <div class="col-xl-12 col-lg-12">
                    <?php echo $__env->make('admin.components.button.form-btn',[
                        'class'         => "w-100 btn-loading",
                        'text'          => __("Update"),
                        'permission'    => "admin.web.settings.basic.settings.update",
                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                </div>
            </form>
        </div>
    </div>
    <div class="custom-card mt-15">
        <div class="card-header">
            <h6 class="title"><?php echo e(__("Activation Settings")); ?></h6>
        </div>
        <div class="card-body">
            <div class="custom-inner-card mt-10 mb-10">
                <div class="card-inner-body">
                    <div class="row mb-10-none">
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Frontend Mode'),
                                'name'          => 'frontend_mode',
                                'value'         => old('frontend_mode',$basic_settings->frontend_mode),
                                'options'       => [ __('Modern( NEXT.JS )') => 1, __('Classic') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('User Registration'),
                                'name'          => 'user_registration',
                                'value'         => old('user_registration',$basic_settings->user_registration),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Secure Password'),
                                'name'          => 'secure_password',
                                'value'         => old('secure_password',$basic_settings->secure_password),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Agree Policy'),
                                'name'          => 'agree_policy',
                                'value'         => old('agree_policy',$basic_settings->agree_policy),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         =>__( 'Force SSL'),
                                'name'          => 'force_ssl',
                                'value'         => old('force_ssl',$basic_settings->force_ssl),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Email Verification'),
                                'name'          => 'email_verification',
                                'value'         => old('email_verification',$basic_settings->email_verification),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Email Notification'),
                                'name'          => 'email_notification',
                                'value'         => old('email_notification',$basic_settings->email_notification),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('Push Notification'),
                                'name'          => 'push_notification',
                                'value'         => old('push_notification',$basic_settings->push_notification),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                        <div class="col-xl-3 col-lg-3 col-md-6 col-sm-6 form-group">
                            <?php echo $__env->make('admin.components.form.switcher',[
                                'label'         => __('KYC Verification'),
                                'name'          => 'kyc_verification',
                                'value'         => old('kyc_verification',$basic_settings->kyc_verification),
                                'options'       => [__('Activated') => 1,__('Deactivated') => 0],
                                'onload'        => true,
                                'permission'    => "admin.web.settings.basic.settings.activation.update",
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>
    <script>
        $(document).ready(function() {
            var baseURL         = "<?php echo e(url('/')); ?>";
            var adminPrefix     = "<?php echo e($basic_settings->admin_prefix); ?>";
            var loginURL        = baseURL + '/' + adminPrefix + '/login';
            $('.login-url').text(`<?php echo e(__('Admin Login URL :')); ?> ${loginURL}`)

            $(".color-picker").on("input",function() {
                $(this).siblings("input").val($(this).val());
            });
            $(".color-input").on('keyup', function(){
                $(this).siblings("input").val($(this).val());
            })
            // Get Timezone
            getTimeZones("<?php echo e(setRoute('global.timezones')); ?>");

            switcherAjax("<?php echo e(setRoute('admin.web.settings.basic.settings.activation.update')); ?>");

        });

        $('input[name=admin_prefix]').keyup(function(){

            var baseURL         = "<?php echo e(url('/')); ?>";
            var adminPrefix     = $(this).val();
            var loginURL        = baseURL + '/' + adminPrefix + '/login';

            $('.login-url').text(`<?php echo e(__('Admin Login URL :')); ?> ${loginURL}`)
        });
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('admin.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/sections/web-settings/basic-settings.blade.php ENDPATH**/ ?>