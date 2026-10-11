<?php if(admin_permission_by_name("admin.setup.email.test.mail.send")): ?>
    <div id="test-mail" class="mfp-hide medium">
        <div class="modal-data">
            <div class="modal-header px-0">
                <h5 class="modal-title"><?php echo e(__("Send Test Mail")); ?></h5>
            </div>
            <div class="modal-form-data">
                <form class="modal-form" method="POST" action="<?php echo e(setRoute('admin.setup.email.test.mail.send')); ?>" enctype="multipart/form-data">
                    <?php echo csrf_field(); ?>
                    <div class="row mb-10-none mt-3">
                        <div class="col-xl-12 col-lg-12 form-group">
                            <?php echo $__env->make('admin.components.form.input',[
                                'label'         =>__( "Email")."*",
                                'name'          => "email",
                                'type'          => "email",
                                'value'         => old("email"),
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>

                        <div class="col-xl-12 col-lg-12 form-group d-flex align-items-center justify-content-between mt-4">
                            <button type="button" class="btn btn--danger modal-close"><?php echo e(__("Cancel")); ?></button>
                            <button type="submit" class="btn btn--base"><?php echo e(__("Send")); ?></button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
<?php endif; ?>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/components/modals/send-text-mail.blade.php ENDPATH**/ ?>