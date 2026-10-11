<?php $__env->startSection('breadcrumb'); ?>
    <?php echo $__env->make('user.components.breadcrumb',['breadcrumbs' => [
        [
            'name'  => __("Dashboard"),
            'url'   => setRoute("user.dashboard"),
        ]
    ], 'active' => __("Dashboard")], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
<div class="body-wrapper">
    <div class="dashboard-area mt-10">
        <div class="dashboard-header-wrapper">
            <h3 class="title"><?php echo e(__("Welcome Back")); ?>, <span><?php echo e(@$user->fullname); ?></span></h3>
        </div>
        <?php if(module_access('virtual-card',$module)->status): ?>
         <!-- Dashboard Card -->
        <div class="row justify-content-center">
            <div class="col-xxl-6 col-xl-8 col-lg-10 col-md-12 col-sm-12 mb-40">
                <div class="dashboard-card-content">
                    <div class="virtualCard-slider-wrapper">
                        <div class="virtualCard-slider">

                            <div class="swiper-wrapper">

                                <?php if($totalCards  < $card_limit || $card_limit == 0): ?>
                                    <?php echo $__env->make('user.components.cards.remaining.index', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php endif; ?>

                                <?php if(virtual_card_system('flutterwave') == "flutterwave"): ?>
                                    <?php echo $__env->make("user.components.cards.flutterwave.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php elseif(virtual_card_system('sudo') == "sudo"): ?>
                                    <?php echo $__env->make("user.components.cards.sudo.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php elseif(virtual_card_system('stripe') == "stripe"): ?>
                                    <?php echo $__env->make("user.components.cards.stripe.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php elseif(virtual_card_system('strowallet') == "strowallet"): ?>
                                    <?php echo $__env->make("user.components.cards.strowallet.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php elseif(virtual_card_system('cardyfie') == "cardyfie"): ?>
                                    <?php echo $__env->make("user.components.cards.cardyfie.index",[
                                        'data'  => $active_virtual_cards_data ?? []
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                <?php endif; ?>

                            </div>
                            <div class="slider-nav-area">
                                <div class="slider-prev slider-nav mt-4">
                                    <i class="las la-angle-left"></i>
                                </div>
                                <div class="slider-next slider-nav mt-4">
                                    <i class="las la-angle-right"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <?php endif; ?>

        <div class="dashboard-item-area">
            <div class="row mb-20-none">
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Current Balance")); ?></span>
                            <h4 class="title"><?php echo e(@$baseCurrency->symbol); ?><?php echo e(authWalletBalance()); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="las la-dollar-sign"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Total Add Money")); ?></span>
                            <h4 class="title"><?php echo e(@$baseCurrency->symbol); ?><?php echo e(getAmount($totalAddMoney ?? 0,get_wallet_precision())); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-cloud-upload-alt"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Total Transactions")); ?></span>
                            <h4 class="title"><?php echo e(@$baseCurrency->symbol); ?><?php echo e(getAmount($totalTransactions ?? 0,get_wallet_precision())); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-dollar-sign"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Active Tickets")); ?></span>
                            <h4 class="title"><?php echo e(@$active_tickets); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-recycle"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Active Card")); ?></span>
                            <h4 class="title"><?php echo e(@$virtualCards); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon fas fa-credit-card"></i>
                        </div>
                    </div>
                </div>
                <div class="col-xxl-3 col-xl-4 col-lg-4 col-md-6 col-sm-6 mb-20">
                    <div class="dashbord-item">
                        <div class="dashboard-content">
                            <span class="sub-title"><?php echo e(__("Total Gift Cards")); ?></span>
                            <h4 class="title"><?php echo e($totalGiftCards); ?></h4>
                        </div>
                        <div class="dashboard-icon">
                            <i class="menu-icon las la-credit-card"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-area mt-60">
        <div class="dashboard-header-wrapper">
            <h4 class="title"><?php echo e(__("Latest Transactions")); ?></h4>
            <div class="dashboard-btn-wrapper">
                <div class="dashboard-btn">
                    <a href="<?php echo e(setRoute('user.transactions.index','virtual-card')); ?>" class="btn--base"><?php echo e(__("View More")); ?></a>
                </div>
            </div>
        </div>
    </div>
    <div class="dashboard-list-wrapper">
        <?php echo $__env->make('user.components.transaction-log',compact("transactions"), array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
    </div>

</div>
<?php $__env->stopSection(); ?>
<?php $__env->startPush('script'); ?>
<script>
    var swiper = new Swiper(".virtualCard-slider", {
            slidesPerView: 1,
            spaceBetween: 60,
            loop: true,
            navigation: {
                nextEl: '.slider-next',
                prevEl: '.slider-prev',
            },
            speed: 1000,
            breakpoints: {
                1199: {
                    slidesPerView: 1,
                },
                991: {
                    slidesPerView: 1,
                },
                767: {
                    slidesPerView: 1,
                },
                575: {
                    slidesPerView: 1,
                },
            }
        });

</script>

<?php $__env->stopPush(); ?>

<?php echo $__env->make('user.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/dashboard.blade.php ENDPATH**/ ?>