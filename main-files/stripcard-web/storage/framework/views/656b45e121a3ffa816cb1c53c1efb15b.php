

<nav class="navbar-wrapper">
    <div class="dashboard-title-part">
        <div class="left">
            <div class="icon">
                <button class="sidebar-menu-bar">
                    <i class="fas fa-exchange-alt"></i>
                </button>
            </div>

            <?php echo $__env->yieldContent('breadcrumb'); ?>
        </div>
        <div class="right">
            <!-- Dark Mode Toggle -->
            <div class="dark-light header-version-bar" title="Version">
                <i class="las la-sun"></i>
                <i class="las la-moon" style="display: none;"></i>
            </div>
            <div class="language-select">
                <?php
                    $session_lan = session('local')??get_default_language_code();
                ?>

                <select class="nice-select langSel" name="lang_switcher" id="">
                    <?php $__currentLoopData = $__languages; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <option value="<?php echo e($item->code); ?>" <?php if( $session_lan == $item->code): ?> selected  <?php endif; ?>><?php echo e($item->name); ?></option>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </select>
            </div>
            <div class="header-notification-wrapper">

                <button class="notification-icon">
                    <i class="las la-bell"></i>
                </button>
                <div class="notification-wrapper">
                    <div class="notification-header">
                        <h5 class="title"><?php echo e(__("notification")); ?></h5>
                    </div>
                    <ul class="notification-list">
                        <?php $__currentLoopData = get_user_notifications() ?? []; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <li>
                            <div class="thumb">
                                <img src="<?php echo e(auth()->user()->userImage); ?>" alt="user" />
                            </div>
                            <div class="content">
                                <div class="title-area">
                                    <h5 class="title"><?php echo e(__($item->message->title)); ?></h5>
                                    <span class="time"><?php echo e($item->created_at->diffForHumans()); ?></span>
                                </div>
                                <span class="sub-title"><?php echo e($item->message->message ?? ""); ?></span>
                            </div>
                        </li>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                    </ul>
                </div>
            </div>
            <div class="header-user-wrapper">
                <div class="header-user-thumb">
                    <a href="<?php echo e(setRoute('user.profile.index')); ?>"><img src="<?php echo e(auth()->user()->userImage); ?>" alt="client" /></a>
                </div>
            </div>
        </div>
    </div>
</nav>


<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/partials/top-nav.blade.php ENDPATH**/ ?>