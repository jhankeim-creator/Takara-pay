<?php $__env->startPush('css'); ?>
<?php $__env->stopPush(); ?>

<?php $__env->startSection('breadcrumb'); ?>
    <?php echo $__env->make('user.components.breadcrumb', [
        'breadcrumbs' => [
            [
                'name' => __('Dashboard'),
                'url' => setRoute('user.dashboard'),
            ],
        ],
        'active' => __($page_title),
    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <div class="body-wrapper">
        <div class="row mb-20-none">
            <div class="col-xl-6 col-lg-6 mb-20">
                <div class="custom-card mt-10">
                    <div class="dashboard-header-wrapper d-flex justify-content-between">
                        <h4 class="title"><?php echo e(@$page_title); ?></h4>
                        <a href="javascript:void(0)" class="btn--danger btn delete-btn"><?php echo e(__('Delete Account')); ?></a>
                    </div>

                    <div class="card-body profile-body-wrapper">
                        <form class="card-form" action="<?php echo e(setRoute('user.profile.update')); ?>" enctype="multipart/form-data"
                            method="POST">
                            <?php echo csrf_field(); ?>
                            <?php echo method_field('PUT'); ?>
                            <div class="profile-settings-wrapper">
                                <div class="preview-thumb profile-wallpaper">
                                    <div class="avatar-preview">
                                        <div class="profilePicPreview bg_img"
                                            data-background="<?php echo e(get_image('frontend/images/element/profile-bg.jpg')); ?>">
                                        </div>
                                    </div>
                                </div>
                                <div class="profile-thumb-content">
                                    <div class="preview-thumb profile-thumb">
                                        <div class="avatar-preview">
                                            <div class="profilePicPreview bg_img" data-background="<?php echo e($user->userImage); ?>">
                                            </div>
                                        </div>
                                        <div class="avatar-edit">
                                            <input type='file' class="profilePicUpload" name="image"
                                                id="profilePicUpload2" accept=".png, .jpg, .jpeg" />
                                            <label for="profilePicUpload2"><i class="las la-upload"></i></label>
                                        </div>
                                    </div>
                                    <div class="profile-content">
                                        <h6 class="username"><?php echo e(@$user->username); ?></h6>
                                        <ul class="user-info-list mt-md-2">
                                            <li><i class="las la-envelope"></i><?php echo e(@$user->email); ?></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="profile-form-area">
                                <div class="row">
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <label><?php echo e(__('first Name')); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__('first Name')); ?>"
                                            name="firstname" value="<?php echo e(auth()->user()->firstname ?? old('firstname')); ?>">
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <label><?php echo e(__('last Name')); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__('last Name')); ?>"
                                            name="lastname" value="<?php echo e(auth()->user()->lastname ?? old('lastname')); ?>">
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">

                                        <label><?php echo e(__('Country')); ?></label>
                                        <select name="country"
                                            class="form-control select2-auto-tokenize country-select select2-basic trx-type-select"
                                            data-placeholder="<?php echo e(__('Select Country')); ?>"
                                            data-old="<?php echo e(old('country', auth()->user()->address->country ?? '')); ?>"></select>
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <label><?php echo e(__('Phone')); ?></label>
                                        <div class="input-group">
                                            <div class="input-group-text phone-code">+<?php echo e(auth()->user()->mobile_code); ?>

                                            </div>
                                            <input class="phone-code" type="hidden" name="phone_code"
                                                value="<?php echo e(auth()->user()->mobile_code); ?>" />
                                            <input type="text" class="form--control"
                                                placeholder="<?php echo e(__('Enter Phone')); ?>" name="phone"
                                                value="<?php echo e(old('phone', auth()->user()->mobile)); ?>">
                                        </div>

                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <?php echo $__env->make('admin.components.form.input', [
                                            'label' => __('Address'),
                                            'name' => 'address',
                                            'placeholder' => __('Enter Address'),
                                            'value' => old('address', auth()->user()->address->address ?? ''),
                                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <?php echo $__env->make('admin.components.form.input', [
                                            'label' => __('City'),
                                            'name' => 'city',
                                            'placeholder' => __('Enter City'),
                                            'value' => old('city', auth()->user()->address->city ?? ''),
                                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <?php echo $__env->make('admin.components.form.input', [
                                            'label' => __('State'),
                                            'name' => 'state',
                                            'placeholder' => __('Enter State'),
                                            'value' => old('state', auth()->user()->address->state ?? ''),
                                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    </div>
                                    <div class="col-xl-6 col-lg-6 form-group">
                                        <?php echo $__env->make('admin.components.form.input', [
                                            'label' => __('Zip Code'),
                                            'name' => 'zip_code',
                                            'placeholder' => __('Enter Zip Code'),
                                            'value' => old('zip_code', auth()->user()->address->zip ?? ''),
                                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    </div>
                                </div>
                                <div class="col-xl-12 col-lg-12">
                                    <button type="submit" class="btn--base w-100 btn-loading"><?php echo e(__('Update')); ?></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <?php if($user->social_type == 'google'): ?>
                <div class="col-xl-6 col-lg-6 mb-20">
                    <div class="custom-card mt-10">
                        <div class="dashboard-header-wrapper">
                        </div>
                        <div class="card-body">
                            <span><?php echo e(__('You are login by google thanks.')); ?></span>
                        </div>
                    </div>
                </div>
            <?php elseif($user->social_type == 'facebook'): ?>
                <div class="col-xl-6 col-lg-6 mb-20">
                    <div class="custom-card mt-10">
                        <div class="dashboard-header-wrapper">
                        </div>
                        <div class="card-body">
                            <span><?php echo e(__('You are login by facebook thanks.')); ?></span>
                        </div>
                    </div>
                </div>
            <?php else: ?>
                <div class="col-xl-6 col-lg-6 mb-20">
                    <div class="custom-card mt-10">
                        <div class="dashboard-header-wrapper">
                            <h4 class="title"><?php echo e(__('Change Password')); ?></h4>
                        </div>
                        <div class="card-body">
                            <form class="card-form" action="<?php echo e(setRoute('user.profile.password.update')); ?>" method="POST">
                                <?php echo csrf_field(); ?>
                                <?php echo method_field('PUT'); ?>
                                <div class="row">
                                    <div class="col-xl-12 col-lg-12 form-group show_hide_password">
                                        <label><?php echo e(__('Current Password')); ?><span>*</span></label>
                                        <input type="password" required class="form--control" name="current_password"
                                            placeholder="<?php echo e(__('Enter Current Password')); ?>">
                                        <a href="javascript:void(0)" class="show-pass field-icon"><i class="fa fa-eye-slash"
                                                aria-hidden="true"></i></a>
                                    </div>
                                    <div class="col-xl-12 col-lg-12 form-group show_hide_password-2">
                                        <label><?php echo e(__('new Password')); ?><span>*</span></label>
                                        <input type="password" required name="password" class="form--control"
                                            placeholder="<?php echo e(__('Enter Password')); ?>">
                                        <a href="javascript:void(0)" class="show-pass field-icon"><i
                                                class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                    </div>
                                    <div class="col-xl-12 col-lg-12 form-group show_hide_password-3">
                                        <label><?php echo e(__('confirm Password')); ?><span>*</span></label>
                                        <input type="password" required name="password_confirmation"
                                            class="form--control" placeholder="<?php echo e(__('Enter Confirmed Password')); ?>">
                                        <a href="javascript:void(0)" class="show-pass field-icon"><i
                                                class="fa fa-eye-slash" aria-hidden="true"></i></a>
                                    </div>
                                </div>
                                <div class="col-xl-12 col-lg-12">
                                    <button type="submit"
                                        class="btn--base w-100 btn-loading"><?php echo e(__('Change')); ?></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            <?php endif; ?>

        </div>
    </div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>
    <script>
        $(document).ready(function() {
            getAllCountries("<?php echo e(setRoute('global.countries')); ?>");
            $("select[name=country]").change(function() {
                var phoneCode = $("select[name=country] :selected").attr("data-mobile-code");
                placePhoneCode(phoneCode);
            });

            countrySelect(".country-select", $(".country-select").siblings(".select2"));

        });


        $(".delete-btn").click(function() {
            var actionRoute = "<?php echo e(setRoute('user.delete.account')); ?>";
            var target = 1;
            var btnText = '<?php echo e(__('Delete Account')); ?>';
            var projectName = "<?php echo e(@$basic_settings->site_name); ?>";
            var name = $(this).data('name');
            var deleteSureText = '<?php echo e(__('Are you sure to')); ?>';
            var firstText = '<?php echo e(__('If you do not think you will use')); ?>';
            var fullText = '<?php echo e(__('body_text_web')); ?>'

            var message =
                `${deleteSureText} <strong> ${btnText}</strong>?<br>${firstText} “<strong>${projectName}</strong>”  ${fullText}, click “${btnText}”.?`;
            openAlertModal(actionRoute, target, message, btnText, "DELETE");
        });
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('user.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/sections/profile/index.blade.php ENDPATH**/ ?>