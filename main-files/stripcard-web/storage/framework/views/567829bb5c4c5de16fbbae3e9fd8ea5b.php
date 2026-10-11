<?php $__env->startPush('css'); ?>

<?php $__env->stopPush(); ?>

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
    <div class="dashboard-area mt-10">
        <div class="dashboard-header-wrapper">
            <h3 class="title"><?php echo e(__(@$page_title)); ?></h3>
            <div class="dashboard-btn-wrapper">
                <div class="dashboard-btn mb-2">
                    <a target="_balnk" href="<?php echo e(setRoute('user.strowallet.virtual.card.webhook.transaction',$card->card_id)); ?>" class="btn--base"><?php echo e(__("Webhook Logs")); ?></a>
                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-area mt-20">
        <div class="dashboard-list-wrapper">

            <?php if(isset($data) && $data['data'] != null): ?>
                <?php if(array_key_exists('data', $data )): ?>
                    <?php $__currentLoopData = $data['data']['card_transactions'] ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $key => $value): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <div class="dashboard-list-item-wrapper">
                        <div class="dashboard-list-item sent">
                            <div class="dashboard-list-left">
                                <div class="dashboard-list-user-wrapper">
                                    <div class="dashboard-list-user-icon">
                                        <i class="las la-arrow-up"></i>
                                    </div>
                                    <div class="dashboard-list-user-content">
                                        <h4 class="title"> <?php echo e(@$value['narrative']); ?></h4>
                                        <span class="sub-title text--danger"> <span class="badge badge--success ms-2"><?php echo e(__(@$value['status'])); ?></span></span>
                                    </div>
                                </div>
                            </div>
                            <div class="dashboard-list-right">
                                <h4 class="main-money text--base"><?php echo e(@$value['amount']); ?> <?php echo e(@$value['currency']); ?></h4>
                                <h6 class="exchange-money"><?php echo e(date("M-d-Y",strtotime($value['createdAt']))); ?></h6>
                            </div>
                        </div>
                        <div class="preview-list-wrapper">

                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-font"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span><?php echo e(__("Type")); ?></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <span><?php echo e(@$value['type']); ?></span>
                                </div>
                            </div>
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-book-open"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span><?php echo e(__("AppLTrxID")); ?></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <span><?php echo e(@$value['id']); ?></span>
                                </div>
                            </div>
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-qrcode"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span><?php echo e(__("Payment Method")); ?></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <span><?php echo e(@$value['method']); ?></span>
                                </div>
                            </div>
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-user-tag"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span><?php echo e(__("Amount")); ?></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <span><?php echo e(@$value['amount']); ?> <?php echo e(@$value['currency']); ?></span>
                                </div>
                            </div>
                            <div class="preview-list-item">
                                <div class="preview-list-left">
                                    <div class="preview-list-user-wrapper">
                                        <div class="preview-list-user-icon">
                                            <i class="las la-user-tag"></i>
                                        </div>
                                        <div class="preview-list-user-content">
                                            <span><?php echo e(__("Reference")); ?></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="preview-list-right">
                                    <span><?php echo e(@$value['reference']); ?> </span>
                                </div>
                            </div>


                        </div>
                    </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                <?php endif; ?>
            <?php else: ?>
            <div class="alert alert-primary text-center">
                <?php echo e(__("No Record Found!")); ?>

            </div>
            <?php endif; ?>

        </div>
    </div>

</div>
<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>

<?php $__env->stopPush(); ?>

<?php echo $__env->make('user.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/sections/virtual-card-strowallet/trx.blade.php ENDPATH**/ ?>