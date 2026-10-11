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
    ], 'active' => __("Virtual Card Api")], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <div class="custom-card">
        <div class="card-header">
            <h6 class="title"><?php echo e(__("Virtual Card Api")); ?></h6>
            <a href="https:\/\/cardyfie.co" target="_blank" class="btn--base d-none cardyfie-link">
                <i class="las la-link"></i>
                <?php echo e(__("Explore Card Issuing API - Cardyfie")); ?>

            </a>
        </div>
        <div class="card-body">
            <form class="card-form" action="<?php echo e(setRoute('admin.virtual.card.api.update')); ?>" method="POST" enctype="multipart/form-data">
                <?php echo csrf_field(); ?>
                <?php echo method_field("PUT"); ?>
                <div class="row mb-10-none">
                    <div class="col-xl-12   col-lg-12 form-group">
                        <label><?php echo e(__("Name")); ?>*</label>
                        <select class="form--control nice-select" name="api_method">
                            <option disabled><?php echo e(__("Select Platfrom")); ?></option>
                            <option value="cardyfie" <?php if(@$api->config->name == 'cardyfie'): ?> selected <?php endif; ?>><?php echo app('translator')->get('Cardyfie'); ?></option>
                            <option value="stripe" <?php if(@$api->config->name == 'stripe'): ?> selected <?php endif; ?>><?php echo app('translator')->get('Stripe Api'); ?></option>
                            <option value="strowallet" <?php if(@$api->config->name == 'strowallet'): ?> selected <?php endif; ?>><?php echo app('translator')->get('Strowallet Api'); ?></option>
                            <option value="sudo" <?php if(@$api->config->name == 'sudo'): ?> selected <?php endif; ?>><?php echo app('translator')->get('Sudo Africa'); ?></option>
                            <option value="flutterwave" <?php if(@$api->config->name == 'flutterwave'): ?> selected <?php endif; ?>><?php echo app('translator')->get('Flutterwave'); ?></option>
                        </select>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group configForm" id="flutterwave">
                        <div class="row" >
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Secret Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="flutterwave_secret_key" value="<?php echo e(@$api->config->flutterwave_secret_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Secret Hash")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-hashtag"></i></span>
                                    <input type="text" class="form--control" name="flutterwave_secret_hash" value="<?php echo e(@$api->config->flutterwave_secret_hash); ?>">
                                </div>
                            </div>
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Base Url")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="flutterwave_url" value="<?php echo e(@$api->config->flutterwave_url); ?>">
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group configForm" id="sudo">
                        <div class="row" >
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("API Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="sudo_api_key" value="<?php echo e(@$api->config->sudo_api_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <label><?php echo e(__("Vault ID Url")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="sudo_vault_id" value="<?php echo e(@$api->config->sudo_vault_id); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <label><?php echo e(__("Base Url")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="sudo_url" value="<?php echo e(@$api->config->sudo_url); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <?php echo $__env->make('admin.components.form.switcher', [
                                    'label'         =>__('Mode'),
                                    'value'         => old('sudo_mode',@$api->config->sudo_mode),
                                    'name'          => "sudo_mode",
                                    'options'       => [__('Live') => global_const()::LIVE, __('Sandbox') => global_const()::SANDBOX]
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>

                        </div>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group configForm" id="stripe">
                        <div class="row" >
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Public Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="stripe_public_key" value="<?php echo e(@$api->config->stripe_public_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Secret Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="stripe_secret_key" value="<?php echo e(@$api->config->stripe_secret_key); ?>">
                                </div>
                            </div>

                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Base Url")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="stripe_url" value="<?php echo e(@$api->config->stripe_url); ?>">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <?php echo $__env->make('admin.components.form.switcher', [
                                    'label'         => __('Mode'),
                                    'value'         => old('stripe_mode',@$api->config->stripe_mode),
                                    'name'          => "stripe_mode",
                                    'options'       => [__('Live') => global_const()::LIVE,__('Sandbox') => global_const()::SANDBOX]
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group configForm" id="strowallet">
                        <div class="row" >
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <label><?php echo e(__("Public Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="strowallet_public_key" value="<?php echo e(@$api->config->strowallet_public_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <label><?php echo e(__("Secret Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="strowallet_secret_key" value="<?php echo e(@$api->config->strowallet_secret_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 form-group">
                                <label><?php echo e(__("Base Url")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="strowallet_url" value="<?php echo e(@$api->config->strowallet_url); ?>" <?php if($api->config->strowallet_url): ?>
                                    readonly
                                    <?php endif; ?>>
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <?php echo $__env->make('admin.components.form.switcher', [
                                    'label'         => __('Mode'),
                                    'value'         => old('strowallet_mode',@$api->config->strowallet_mode),
                                    'name'          => "strowallet_mode",
                                    'options'       => [__('Live') => global_const()::LIVE,__('Sandbox') => global_const()::SANDBOX]
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-12 form-group">
                                <label><?php echo e(__("Webhook URL")); ?></label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control referralURL"  value="<?php echo e(setRoute('user.strowallet.virtual.card.webhook')); ?>" readonly>
                                    <div class="input-group-text copytext" id="copyBoard"><i class="las la-copy"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>
                     <div class="col-xl-12 col-lg-12 form-group configForm" id="cardyfie">
                        <div class="row" >
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Public Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="cardyfie_public_key" value="<?php echo e(@$api->config->cardyfie_public_key); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Secret Key")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="cardyfie_secret_key" value="<?php echo e(@$api->config->cardyfie_secret_key); ?>">
                                </div>
                            </div>

                           <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Sandbox URL")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="cardyfie_sandbox_url" value="<?php echo e(@$api->config->cardyfie_sandbox_url ?? ''); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Production URL")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control" name="cardyfie_production_url" value="<?php echo e(@$api->config->cardyfie_production_url ?? ''); ?>">
                                </div>
                            </div>

                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Webhook Secret")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-key"></i></span>
                                    <input type="text" class="form--control" name="cardyfie_webhook_secret" value="<?php echo e(@$api->config->cardyfie_webhook_secret ?? ''); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Webhook URL")); ?></label>
                                <div class="input-group append">
                                    <span class="input-group-text"><i class="las la-link"></i></span>
                                    <input type="text" class="form--control referralURL"  value="<?php echo e(setRoute('user.cardyfie.virtual.card.webhook')); ?>" readonly>
                                    <div class="input-group-text copytext" id="copyBoard"><i class="las la-copy"></i></div>
                                </div>
                            </div>

                             <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Universal Card Issue Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_universal_card_issues_fee" value="<?php echo e(get_amount($api->config->cardyfie_universal_card_issues_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>

                             <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Platinum Card Issue Fee")); ?>*</label>
                                <div class="input-group append">
                                    <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_platinum_card_issues_fee" value="<?php echo e(get_amount($api->config->cardyfie_platinum_card_issues_fee ?? 0,null,get_wallet_precision())); ?>">

                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Card Deposit Fixed Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_card_deposit_fixed_fee" value="<?php echo e(get_amount($api->config->cardyfie_card_deposit_fixed_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Card Deposit Percent Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_card_deposit_percent_fee" value="<?php echo e(get_amount($api->config->cardyfie_card_deposit_percent_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Card Withdraw Fixed Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_card_withdraw_fixed_fee" value="<?php echo e(get_amount($api->config->cardyfie_card_withdraw_fixed_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Card Withdraw Percent Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_card_withdraw_percent_fee" value="<?php echo e(get_amount($api->config->cardyfie_card_withdraw_percent_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Card Maintenance Fixed Fee")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_card_maintenance_fixed_fee" value="<?php echo e(get_amount($api->config->cardyfie_card_maintenance_fixed_fee ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Minimum Amount")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_min_limit" value="<?php echo e(get_amount($api->config->cardyfie_min_limit ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Maximum Amount")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_max_limit" value="<?php echo e(get_amount($api->config->cardyfie_max_limit ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Daily Limit")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_daily_limit" value="<?php echo e(get_amount($api->config->cardyfie_daily_limit ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-4 col-lg-4 col-md-12 col-sm-12 form-group">
                                <label><?php echo e(__("Monthly Limit")); ?>*</label>
                                <div class="input-group append">
                                   <span class="input-group-text"><?php echo e(get_default_currency_code()); ?></span>
                                    <input type="text" class="form--control number-input" name="cardyfie_monthly_limit" value="<?php echo e(get_amount($api->config->cardyfie_monthly_limit ?? 0,null,get_wallet_precision())); ?>">
                                </div>
                            </div>
                            <div class="col-xl-3 col-lg-3 col-md-12 col-sm-12 col-sm-12 form-group">
                                <?php echo $__env->make('admin.components.form.switcher', [
                                    'label'         => __('Mode'),
                                    'value'         => old('cardyfie_mode',@$api->config->cardyfie_mode),
                                    'name'          => "cardyfie_mode",
                                    'options'       => [__('Production') => global_const()::LIVE,__('Sandbox') => global_const()::SANDBOX]
                                ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                            </div>

                        </div>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group">
                        <?php echo $__env->make('admin.components.form.input',[
                            'label'         =>__( 'Card Limit').'* ('.__("If Setup is 0, Card Creation is Unlimited").")",
                            'name'          => 'card_limit',
                            'value'         => old('card_limit',@$api->card_limit),
                            'placeholder'   => "Enter Limit.",
                            'class'   => "card-limit-label"

                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group">
                        <?php echo $__env->make('admin.components.form.input-text-rich',[
                            'label'         => __('Card Details').'*',
                            'name'          => 'card_details',
                            'value'         => old('card_details',@$api->card_details),
                            'placeholder'   => "Write Here...",
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                    <div class="col-xl-12 col-lg-12 form-group">
                        <label for="card-image"><?php echo e(__("Background Image")); ?></label>
                        <div class="col-12 col-sm-6 m-auto">
                            <?php echo $__env->make('admin.components.form.input-file',[
                                'label'         => false,
                                'class'         => "file-holder m-auto",
                                'old_files_path'    => files_asset_path('card-api'),
                                'name'          => "image",
                                'old_files'         => old('image',@$api->image)
                            ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        </div>
                    </div>

                    <div class="col-xl-12 col-lg-12 form-group">
                        <?php echo $__env->make('admin.components.button.form-btn',[
                            'class'         => "w-100 btn-loading",
                            'text'          => __("Update"),
                            'permission'    => "admin.virtual.card.api.update"
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    </div>
                </div>
            </form>
        </div>
    </div>
<?php $__env->stopSection(); ?>
<?php $__env->startPush('script'); ?>
    <script>
        (function ($) {
            "use strict";

            var method = '<?php echo e(@$api->config->name); ?>';
            if (!method) {
                method = 'flutterwave';
            }

            apiMethod(method);
            toggleCardyfieLink(method);
            updateCardLimitLabel(method);

            $('select[name=api_method]').on('change', function() {
                var method = $(this).val();
                apiMethod(method);
                toggleCardyfieLink(method);
            });

            function apiMethod(method) {
                $('.configForm').addClass('d-none');
                if (method !== 'other') {
                    $(`#${method}`).removeClass('d-none');
                }
                updateCardLimitLabel(method);
            }

            function toggleCardyfieLink(method) {
                if (method === 'cardyfie') {
                    $('.cardyfie-link').removeClass('d-none');
                } else {
                    $('.cardyfie-link').addClass('d-none');
                }
            }

            function updateCardLimitLabel(method) {
                var label = $('.card-limit-label').closest('.form-group').find('label');

                if (method === 'cardyfie') {
                    label.text('<?php echo e(__("Card Limit* (If Setup is 0, Card Creation is Unlimited)")); ?>');
                } else {
                    label.text('<?php echo e(__("Card limit admin")); ?>');
                }
            }

        })(jQuery);

    </script>
    <script>
        $('.copytext').on('click', function () {
                var copyText = $(this).closest('.input-group').find('.referralURL')[0];
                copyText.select();
                copyText.setSelectionRange(0, 99999);
                document.execCommand("copy");

                throwMessage('success', ['<?php echo e("Copy Successfully"); ?>']);
            });
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('admin.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/sections/virtual-card/api.blade.php ENDPATH**/ ?>