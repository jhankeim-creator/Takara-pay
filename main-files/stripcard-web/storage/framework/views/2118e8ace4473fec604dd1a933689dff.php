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
    ], 'active' => __("Setup Email")], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <?php
        $selected_method = old('method',$email_config->method ?? "smtp");
    ?>
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title"><?php echo e(__("Email Method")); ?></h6>
        </div>
        <div class="card-body">
            <form class="card-form" method="POST" action="<?php echo e(setRoute('admin.setup.email.config.update')); ?>">
                <?php echo csrf_field(); ?>
                <?php echo method_field("PUT"); ?>
                <div class="row mb-10-none">
                    <div class="col-xl-12 col-lg-12">
                        <div class="row align-items-end">
                            <div class="col-xl-10 col-lg-10 form-group">
                                <label><?php echo e(__("Email Send Method")); ?>*</label>
                                <select class="form--control nice-select" name="method">
                                    <option disabled><?php echo e(__("Select Method")); ?></option>
                                    <option value="smtp" <?php if($selected_method == "smtp"): echo 'selected'; endif; ?>>SMTP</option>
                                    <option value="reachead" <?php if($selected_method == "reachead"): echo 'selected'; endif; ?>><?php echo e(__("Reachead")); ?></option>
                                </select>
                                <?php $__errorArgs = ["method"];
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
                            <div class="col-xl-2 col-lg-2 form-group">
                                <!-- Open Modal For Test Email Send -->
                                <?php echo $__env->make('admin.components.link.custom',[
                                    'class'         => "btn--base modal-btn w-100",
                                    'href'          => "#test-mail",
                                    'text'          => __("Send Mail"),
                                    'permission'    => "admin.setup.email.test.mail.send",
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 input-fields smtp-fields" <?php if($selected_method != "smtp"): ?> style="display: none" <?php endif; ?>>
                        <div class="row">
                            <div class="col-xl-5 col-lg-5 form-group">
                                <?php echo $__env->make('admin.components.form.input',[
                                    'label'     =>__( "Host")."*",
                                    'name'      => 'host',
                                    'value'     => old('host',$email_config->host ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-5 col-lg-5 form-group">
                                <?php echo $__env->make('admin.components.form.input',[
                                    'label'     => __("Port")."*",
                                    'name'      => 'port',
                                    'type'      => 'number',
                                    'value'     => old('port',$email_config->port ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-2 col-lg-2 form-group">
                                <?php echo $__env->make('admin.components.form.switcher',[
                                    'label'     => __("Encryption")."*",
                                    'name'      => 'encryption',
                                    'options'   => ['SSL' => "ssl",'TLS' => "tls"],
                                    'value'     => old('encryption',$email_config->encryption ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                <?php echo $__env->make('admin.components.form.input',[
                                    'label'     => __("Username")."*",
                                    'name'      => 'username',
                                    'value'     => old('username',$email_config->username ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                <?php echo $__env->make('admin.components.form.input',[
                                    'label'     => __("From Address")."*",
                                    'name'      => 'from_address',
                                    'value'     => old('from_address',$email_config->from_address ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-4 col-lg-4 form-group">
                                <?php echo $__env->make('admin.components.form.email-input-password',[
                                    'label'         => __('password').'*',
                                    'placeholder'   => 'Password' ,
                                    'name'          => 'password',
                                    'value'         => old('password',$email_config->password ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 input-fields reachead-fields" <?php if($selected_method != "reachead"): ?> style="display: none" <?php endif; ?>>
                        <div class="row">
                            <div class="col-xl-6 col-lg-6 form-group">
                                <?php echo $__env->make('admin.components.form.input',[
                                    'label'         => __("From Address")."*",
                                    'placeholder'   => __("From Address"),
                                    'name'          => 'reachead_from_address',
                                    'value'         => old('reachead_from_address',$email_config->from_address ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-6 col-lg-6 form-group">
                                <?php echo $__env->make('admin.components.form.email-input-password',[
                                    'label'         => __("Api Key")."*",
                                    'placeholder'   => __("Api Key"),
                                    'name'          => 'reachead_api_key',
                                    'value'         => old('reachead_api_key',$email_config->api_key ?? ""),
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group">
                        <?php echo $__env->make('admin.components.button.form-btn',[
                            'class'         => "w-100 btn-loading",
                            'text'          => __("Update"),
                            'permission'    => "admin.setup.email.config.update",
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                </div>
            </form>
        </div>
    </div>

    
    <?php echo $__env->make('admin.components.modals.send-text-mail', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>

<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>
    <script>
        $("select[name=method]").change(function(){
            $(".input-fields").hide();
            $("."+$(this).val()+"-fields").show();
        });
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('admin.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/sections/setup-email/config.blade.php ENDPATH**/ ?>