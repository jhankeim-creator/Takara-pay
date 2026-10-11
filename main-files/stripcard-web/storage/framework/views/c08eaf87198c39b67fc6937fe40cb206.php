<?php $__env->startSection('breadcrumb'); ?>
    <?php echo $__env->make('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __(@$page_title)], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<div class="body-wrapper">
    <div class="row justify-content-center">
        <div class="col-xl-8">
            <div class="dash-payment-item-wrapper">
                <div class="dash-payment-item active">
                    <div class="text-center">
                       <h4 class="text-muted"><?php echo e(__("A cardholder is required before creating a card. Please create a cardholder first.")); ?></h4>
                    </div>
                    <div class="dash-payment-body">
                        <div class=" mt-20 ">
                             <form class="card-form row g-4" action="<?php echo e(route('user.strowallet.virtual.card.store.customer')); ?>" method="POST">
                                <?php echo csrf_field(); ?>

                                <div class="col-lg-12">
                                    <div class="form-group">
                                        <label><?php echo e(__("Name")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("enter Name")); ?>" name="name" value="<?php echo e(old('name', $customer_kyc->name ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("first Name")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("enter First Name")); ?>" name="first_name" value="<?php echo e(old('first_name', $customer_kyc->first_name ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("last Name")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("enter Last Name")); ?>" name="last_name" value="<?php echo e(old('last_name', $customer_kyc->last_name ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Date Of Birth")); ?><span>*</span></label>
                                        <input type="date" class="form--control" required placeholder="<?php echo e(__("Enter Date Of Birth")); ?>" name="dob" value="<?php echo e(old('dob', $customer_kyc->dob ?? "")); ?>">
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("ID Type")); ?><span>*</span></label>
                                        <select class="form--control nice-select" name="id_type" required>
                                            <option value=""><?php echo e(__("Select ID Type")); ?></option>
                                            <option value="national_id" <?php echo e(old('id_type', $customer_kyc->id_type ?? '') == 'national_id' ? 'selected' : ''); ?>><?php echo e(__("National ID")); ?></option>
                                            <option value="passport" <?php echo e(old('id_type', $customer_kyc->id_type ?? '') == 'passport' ? 'selected' : ''); ?>><?php echo e(__("Passport")); ?></option>
                                            <option value="drivers_license" <?php echo e(old('id_type', $customer_kyc->id_type ?? '') == 'drivers_license' ? 'selected' : ''); ?>><?php echo e(__("Driver's License")); ?></option>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("ID Number")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("Enter ID Number")); ?>" name="id_number" value="<?php echo e(old('id_number', $customer_kyc->id_number ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Email")); ?><span>*</span></label>
                                        <input type="email" class="form--control" placeholder="<?php echo e(__("enter Email Address")); ?>" name="email" value="<?php echo e(old('email', $customer_kyc->email ?? auth()->user()->email)); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Address Line 1")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("Enter Address")); ?>" name="line1" value="<?php echo e(old('line1', $customer_kyc->line1 ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("City")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("Enter City")); ?>" name="city" value="<?php echo e(old('city', $customer_kyc->city ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("State")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("Enter State")); ?>" name="state" value="<?php echo e(old('state', $customer_kyc->state ?? "")); ?>" required>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Zip/Postal")); ?><span>*</span></label>
                                        <input type="text" class="form--control" placeholder="<?php echo e(__("Enter Zip Code")); ?>" name="postal_code" value="<?php echo e(old('postal_code', $customer_kyc->postal_code ?? "")); ?>" required>
                                    </div>
                                </div>


                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Country")); ?><span>*</span></label>
                                        <select name="country"class="form-control select2-auto-tokenize country-select select2-basic trx-type-select">
                                            <option value="" disabled selected><?php echo e(__("Select Country")); ?></option>
                                            <?php $__currentLoopData = get_all_countries() ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $country): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                                <option value="<?php echo e($country->iso3); ?>" <?php echo e(old('country', $customer_kyc->country ?? '') == $country->iso3 ? 'selected' : ''); ?> data-mobile-code="<?php echo e($country->mobile_code); ?>"><?php echo e($country->name); ?></option>
                                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                        </select>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="form-group">
                                        <label><?php echo e(__("Phone")); ?><span>*</span></label>
                                        <div class="input-group">
                                            <div class="input-group-text phone-code">+<?php echo e($customer_kyc->phone_code ?? auth()->user()->mobile_code); ?>

                                            </div>
                                            <input class="phone-code" type="hidden" name="phone_code"
                                                value="<?php echo e($customer_kyc->phone_code ?? auth()->user()->mobile_code); ?>" />
                                            <input type="text" class="form--control"
                                                placeholder="<?php echo e(__('enter Phone Number')); ?>" name="phone"
                                                value="<?php echo e(old('phone', $customer_kyc->phone ?? auth()->user()->mobile)); ?>"
                                                >
                                        </div>
                                    </div>
                                </div>

                                 <div class="col-xl-12 col-lg-12 form-group">
                                    <?php echo $__env->make('admin.components.form.input-file',[
                                        'label'             => __("ID Image"),
                                        'name'              => "id_image",
                                        'class'             => "file-holder",
                                        'old_files_path'    => files_asset_path('card-kyc-images'),
                                        'old_files'         => $customer_kyc->id_image ?? '',
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                </div>

                                <?php if(!$customer_kyc): ?>
                                    <div class="col-lg-12">
                                        <div class="button pt-3">
                                            <button type="submit" class="btn btn--base w-100 btn-loading buyBtn"><?php echo e(__("Confirm")); ?></button>
                                        </div>
                                    </div>

                                <?php endif; ?>

                            </form>
                        </div>

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
            $("select[name=country]").change(function() {
                var phoneCode = $("select[name=country] :selected").attr("data-mobile-code");
                placePhoneCode(phoneCode);
            });

        });

    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('user.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/sections/virtual-card-strowallet/customer/edit.blade.php ENDPATH**/ ?>