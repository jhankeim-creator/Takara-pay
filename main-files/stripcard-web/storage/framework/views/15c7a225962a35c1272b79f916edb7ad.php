

<div class="col-lg-6 col-md-8 pb-30">
    <div class="deposit-form">
        <div class="form-title text-center">
            <h3 class="title"><?php echo e(__($page_title)); ?></h3>
        </div>
        <div class="row justify-content-center">
            <form class="card-form row g-4" action="<?php echo e(route('user.strowallet.virtual.card.create')); ?>" method="POST">
             <?php echo csrf_field(); ?>

                <div class="col-lg-12">
                    <div class="form-group">
                        <label><?php echo e(__("Card Amount")); ?><span>*</span></label>
                        <input type="number" class="form--control card_amount" id="card_amount" required placeholder="<?php echo e(__("Enter Amount")); ?>" name="card_amount" value="<?php echo e(old("card_amount")); ?>">
                        <select class="currency nice-select" name="currency">
                            <?php $__currentLoopData = $supported_currency; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <option value="<?php echo e($item->currency_code); ?>"
                                data-code="<?php echo e($item->currency_code); ?>"
                                data-symbol="<?php echo e($item->symbol); ?>"
                                data-rate="<?php echo e($item->rate); ?>"
                                data-wallet="<?php echo e($item->id); ?>"
                                data-currency-id="<?php echo e($item->id); ?>"
                                data-name="<?php echo e($item->country); ?>"><?php echo e($item->currency_code); ?></option>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </select>
                    </div>
                </div>

                

                <div class="col-lg-12">
                    <div class="form-group">
                        <label><?php echo e(__("From Wallet")); ?> <span class="text--base">*</span></label>
                        <select class="form--control select2-auto-tokenize" name="from_currency">
                            <?php $__currentLoopData = $from_wallets; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                            <option value="<?php echo e($item->currency->code); ?>"
                                data-code="<?php echo e($item->currency->code); ?>"
                                data-symbol="<?php echo e($item->currency->symbol); ?>"
                                data-rate="<?php echo e($item->currency->rate); ?>"
                                data-type="<?php echo e($item->currency->type); ?>"
                                data-balance="<?php echo e($item->balance); ?>"
                                data-wallet="<?php echo e($item->id); ?>"
                                data-currency-id="<?php echo e($item->currency->id); ?>"
                                data-name="<?php echo e($item->currency->country); ?>"><?php echo e(ucwords($item->currency->name) ."( ".get_amount($item->balance,$item->currency->code,get_wallet_precision())." )"); ?></option>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </select>
                        <div class="note-area mt-10">
                            <code class="d-block fees-show">--</code>
                            <code class="d-block"><?php echo e(__("Available Balance")); ?> <?php echo e(authWalletBalance()); ?> <?php echo e(get_default_currency_code()); ?></code>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="button pt-3">
                        <button type="submit" class="btn btn--base w-100 btn-loading buyBtn"><?php echo e(__("Confirm")); ?></button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="col-lg-6 col-md-4">
    <div class="deposit-form">
        <div class="form-title text-center pb-4">
            <h3 class="title"><?php echo e(__("preview")); ?></h3>
        </div>
        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span><?php echo e(__("Card Amount")); ?></span>
            </div>
            <div class="preview-content">
                <p class="request-amount">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span><?php echo e(__("Exchange Rate")); ?></span>
            </div>
            <div class="preview-content">
                <p class="exchange-rate">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span><?php echo e(__("Total Charge")); ?></span>
            </div>
            <div class="preview-content">
                <p class="fees">--</p>
            </div>
        </div>

        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span><?php echo e(__("Total Payable Amount")); ?></span>
            </div>
            <div class="preview-content">
                <p class="payable-total">--</p>
            </div>
        </div>

    </div>
    
    <div class="deposit-form my-3">
        <div class="form-title text-center pb-4">
            <h3 class="title"><?php echo e(__("Limit Information")); ?></h3>
        </div>
        <div class="preview-item d-flex justify-content-between">
            <div class="preview-content">
                <span><?php echo e(__("Transaction Limit")); ?></span>
            </div>
            <div class="preview-content">
                <span class="limit-show">--</span>
            </div>
        </div>
        <?php if($cardCharge->daily_limit > 0): ?>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span><?php echo e(__("Daily Limit")); ?></span>
                </div>
                <div class="preview-content">
                    <span class="limit-daily">--</span>
                </div>
            </div>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span><?php echo e(__("Remaining Daily Limit")); ?></span>
                </div>
                <div class="preview-content">
                    <span class="daily-remaining">--</span>
                </div>
            </div>
        <?php endif; ?>
        <?php if($cardCharge->monthly_limit > 0): ?>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span><?php echo e(__("Monthly Limit")); ?></span>
                </div>
                <div class="preview-content">
                    <span class="limit-monthly">--</span>
                </div>
            </div>
            <div class="preview-item d-flex justify-content-between">
                <div class="preview-content">
                    <span><?php echo e(__("Remaining Monthly Limit")); ?></span>
                </div>
                <div class="preview-content">
                    <span class="monthly-remaining">--</span>
                </div>
            </div>
        <?php endif; ?>

    </div>
</div>
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
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/sections/virtual-card-strowallet/component/create-card.blade.php ENDPATH**/ ?>