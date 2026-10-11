<?php $__env->startSection('breadcrumb'); ?>
    <?php echo $__env->make('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __($page_title)], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>
<?php $__env->startSection('content'); ?>
<div class="body-wrapper">
    <div class="table-area mt-20">
        <div class="table-wrapper">
            <div class="dashboard-header-wrapper">
                <h4 class="title"><?php echo e(__($page_title)); ?></h4>
                <div class="dashboard-btn-wrapper">
                    <div class="dashboard-btn">
                        <a href="<?php echo e(setRoute('user.gift.card.list')); ?>" class="btn--base"><i class="las la-plus me-1"></i> <?php echo e(__("Gift Cards")); ?></a>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th><?php echo e(__("TRX ID")); ?></th>
                            <th><?php echo e(__("Card Name")); ?></th>
                            <th><?php echo e(__("Card Images")); ?></th>
                            <th><?php echo e(__("receiver Email")); ?></th>
                            <th><?php echo e(__("Receiver Phone")); ?></th>
                            <th><?php echo e(__("Card Unit Price")); ?></th>
                            <th><?php echo e(__("Card Quantity")); ?></th>
                            <th><?php echo e(__("Card Total Price")); ?></th>
                            <th><?php echo e(__("Exchange Rate")); ?></th>
                            <th><?php echo e(__("Payable Unit Price")); ?></th>
                            <th><?php echo e(__("Total Charge")); ?></th>
                            <th><?php echo e(__("Payable Amount")); ?></th>
                            <th><?php echo e(__("Status")); ?></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__empty_1 = true; $__currentLoopData = $giftCards ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <tr>
                            <td><?php echo e($item->trx_id); ?></td>
                            <td><?php echo e($item->card_name); ?></td>
                            <td><img style="max-width: 50px" src="<?php echo e($item->card_image); ?> " alt=""></td>
                            <td><?php echo e($item->recipient_email); ?></td>
                            <td>+<?php echo e($item->recipient_phone); ?></td>
                            <td><?php echo e(get_amount($item->card_amount,$item->card_currency)); ?></td>
                            <td><?php echo e($item->qty); ?></td>
                            <td><?php echo e(get_amount($item->card_total_amount,$item->card_currency)); ?></td>
                            <td><?php echo e(get_amount(1,$item->card_currency) ." = ". get_amount($item->exchange_rate,$item->user_wallet_currency)); ?></td>
                            <td><?php echo e(get_amount($item->unit_amount,$item->user_wallet_currency)); ?></td>
                            <td><?php echo e(get_amount($item->total_charge,$item->user_wallet_currency)); ?></td>
                            <td><?php echo e(get_amount($item->total_payable,$item->user_wallet_currency)); ?></td>
                            <td><span class="<?php echo e($item->stringStatus->class); ?>"><?php echo e(__($item->stringStatus->value)); ?> </span></td>
                        </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="13"><div class="alert alert-primary" style="margin-top: 37.5px; text-align:center"><?php echo e(__("No data found!")); ?></div></td>
                        </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
                <?php echo e(get_paginate($giftCards)); ?>

            </div>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>
<?php $__env->startPush('script'); ?>

<?php $__env->stopPush(); ?>

<?php echo $__env->make('user.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/sections/gift-card/index.blade.php ENDPATH**/ ?>