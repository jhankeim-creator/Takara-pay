<div class="sidebar">
    <div class="sidebar-inner">
        <div class="sidebar-inner-wrapper">
            <div class="sidebar-logo">
                <a class="site-logo sidebar-main-logo site-title" href="<?php echo e(setRoute('index')); ?>">
                    <img src="<?php echo e(get_logo($basic_settings)); ?>" data-white_img="<?php echo e(get_logo($basic_settings, 'white')); ?>"
                        data-dark_img="<?php echo e(get_logo($basic_settings, 'dark')); ?>" alt="site-logo">
                </a>
                <button class="sidebar-menu-bar">
                    <i class="fas fa-exchange-alt"></i>
                </button>
            </div>
            <div class="sidebar-menu-wrapper">
                <ul class="sidebar-menu">
                    <li class="sidebar-menu-item">
                        <a href="<?php echo e(setRoute('user.dashboard')); ?>">
                            <i class="menu-icon las la-palette"></i>
                            <span class="menu-title"><?php echo e(__('Dashboard')); ?></span>
                        </a>
                    </li>
                    <?php if(module_access('add-money', $module)->status): ?>
                        <li class="sidebar-menu-item">
                            <a href="<?php echo e(setRoute('user.add.money.index')); ?>">
                                <i class="menu-icon las la-cloud-upload-alt"></i>
                                <span class="menu-title"><?php echo e(__('Add Money')); ?></span>
                            </a>
                        </li>
                    <?php endif; ?>
                    <?php if(module_access('transfer-money', $module)->status): ?>
                        <li class="sidebar-menu-item">
                            <a href="<?php echo e(setRoute('user.transfer.money.index')); ?>">
                                <i class="menu-icon las la-paper-plane"></i>
                                <span class="menu-title"><?php echo e(__('transfer Money')); ?></span>
                            </a>
                        </li>
                    <?php endif; ?>
                    <?php if(module_access('withdraw-money', $module)->status): ?>
                        <li class="sidebar-menu-item">
                            <a href="<?php echo e(setRoute('user.withdraw.index')); ?>">
                                <i class="menu-icon las la-arrow-circle-left"></i>
                                <span class="menu-title"><?php echo e(__('Withdraw Money')); ?></span>
                            </a>
                        </li>
                    <?php endif; ?>

                    <li class="sidebar-menu-item">
                        <a href="<?php echo e(setRoute('user.profile.index')); ?>">
                            <i class="menu-icon las la-user"></i>
                            <span class="menu-title"><?php echo e(__('My Profile')); ?></span>
                        </a>
                    </li>
                    <?php if(module_access('gift-cards', $module)->status): ?>
                        <li class="sidebar-menu-item">
                            <a href="<?php echo e(setRoute('user.gift.card.index')); ?>">
                                <i class="menu-icon las la-credit-card"></i>
                                <span class="menu-title"><?php echo e(__('Gift Card')); ?></span>
                            </a>
                        </li>
                    <?php endif; ?>
                    <li class="sidebar-menu-item">
                        <a href="<?php echo e(setRoute('user.transactions.index')); ?>">
                            <i class="menu-icon las la-recycle"></i>
                            <span class="menu-title"><?php echo e(__('Transactions')); ?></span>
                        </a>
                    </li>
                    <?php if($basic_settings->kyc_verification): ?>
                        <li class="sidebar-menu-item">
                            <a href="<?php echo e(setRoute('user.authorize.kyc')); ?>">
                                <i class="las la-user-shield menu-icon"></i>
                                <span class="menu-title"><?php echo e(__('KYC Verification')); ?></span>
                            </a>
                        </li>
                    <?php endif; ?>
                    <li class="sidebar-menu-item">
                        <a href="<?php echo e(setRoute('user.security.google.2fa')); ?>">
                            <i class="menu-icon fas fa-qrcode"></i>
                            <span class="menu-title"><?php echo e(__('2FA Security')); ?></span>
                        </a>
                    </li>
                    <li class="sidebar-menu-item">
                        <a href="javascript:void(0)" class="logout-btn">
                            <i class="menu-icon las la-sign-out-alt"></i>
                            <span class="menu-title"><?php echo e(__('Logout')); ?></span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="sidebar-doc-box bg_img" data-background="<?php echo e(get_image('frontend/images/element/side-bg.webp')); ?>">
            <div class="sidebar-doc-icon">
                <i class="fas fa-question-circle"></i>
            </div>
            <div class="sidebar-doc-content">
                <h4 class="title"><?php echo e(__('help Center')); ?></h4>
                <p><?php echo e(__('How can we help you')); ?><?php echo e('?'); ?></p>
                <div class="sidebar-doc-btn">
                    <a href="<?php echo e(setRoute('user.support.ticket.index')); ?>"
                        class="btn--base w-100"><?php echo e(__('Get Support')); ?></a>
                </div>
            </div>
        </div>
    </div>
</div>

<?php $__env->startPush('script'); ?>
    <script>
        $(".logout-btn").click(function() {
            var actionRoute = "<?php echo e(setRoute('user.logout')); ?>";
            var target = 1;
            var sureText = '<?php echo e(__('Are you sure to')); ?>';
            var message = `${sureText} <strong><?php echo e(__('Logout')); ?></strong>?`;
            var logout = `<?php echo e(__('Logout')); ?>`;
            openAlertModal(actionRoute, target, message, logout, "POST");
        });
    </script>
<?php $__env->stopPush(); ?>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/partials/side-nav.blade.php ENDPATH**/ ?>