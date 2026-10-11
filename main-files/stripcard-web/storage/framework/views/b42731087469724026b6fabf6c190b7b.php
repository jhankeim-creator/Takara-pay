<div class="custom-card mb-10">
    <div class="card-header">
        <h6 class="title"><?php echo e(__($title) ?? ""); ?></h6>
    </div>
    <div class="card-body">
        <form class="card-form" method="POST" action="<?php echo e($route ?? ""); ?>">
            <?php echo csrf_field(); ?>
            <?php echo method_field("PUT"); ?>

            <input type="hidden" value="<?php echo e($item->slug); ?>" name="slug">
                 <?php
                    if($item->slug == 'virtual_card' || $item->slug == 'virtual_card_withdraw'){
                        $colLg = 'col-xl-6';
                        $colXl = 'col-lg-6';
                    }else{
                        $colLg = 'col-xl-6';
                        $colXl = 'col-lg-6';
                    }
                ?>
            <div class="row">
                <div class="col-xl-6 col-lg-4 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title"><?php echo e(__("Charges")); ?></h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label><?php echo e(__("Fixed Charge")); ?>*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_fixed_charge',get_amount($data->fixed_charge,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_fixed_charge">
                                        <span class="input-group-text"><?php echo e(get_default_currency_code($default_currency)); ?></span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label><?php echo e(__("Percent Charge")); ?>*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_percent_charge',get_amount($data->percent_charge,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_percent_charge">
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6 col-lg-4 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title"><?php echo e(__("Range")); ?></h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6  form-group">
                                    <label><?php echo e(__("Minimum Amount")); ?></label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_min_limit',get_amount($data->min_limit,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_min_limit">
                                        <span class="input-group-text"><?php echo e(get_default_currency_code($default_currency)); ?></span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label><?php echo e(__("Maximum Amount")); ?></label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_max_limit',get_amount($data->max_limit,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_max_limit">
                                        <span class="input-group-text"><?php echo e(get_default_currency_code($default_currency)); ?></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xl-12 col-lg-12 mb-10">
                    <div class="custom-inner-card">
                        <div class="card-inner-header">
                            <h5 class="title"><?php echo e(__("limit")); ?> <span class="small text--base">(<?php echo e(__("Execute if the value is greater than zero")); ?>)</span></h5>
                        </div>
                        <div class="card-inner-body">
                            <div class="row">
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label><?php echo e(__("Daily Limit")); ?>*</label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_daily_limit',get_amount($data->daily_limit,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_daily_limit">
                                        <span class="input-group-text"><?php echo e(get_default_currency_code($default_currency)); ?></span>
                                    </div>
                                </div>
                                <div class="col-xxl-12 col-xl-6 col-lg-6 form-group">
                                    <label><?php echo e(__("Monthly Limit")); ?>* </label>
                                    <div class="input-group">
                                        <input type="text" class="form--control number-input" value="<?php echo e(old($data->slug.'_monthly_limit',get_amount($data->monthly_limit,null,get_wallet_precision()))); ?>" name="<?php echo e($data->slug); ?>_monthly_limit">
                                        <span class="input-group-text"><?php echo e(get_default_currency_code($default_currency)); ?></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="row mb-10-none">
                <div class="col-xl-12 col-lg-12 form-group">
                    <?php echo $__env->make('admin.components.button.form-btn',[
                        'text'          => __("Update"),
                        'class'         => "w-100 btn-loading",
                        'permission'    => "admin.trx.settings.charges.update",
                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                </div>
            </div>
        </form>
    </div>
</div>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/components/trx-settings-charge-block.blade.php ENDPATH**/ ?>