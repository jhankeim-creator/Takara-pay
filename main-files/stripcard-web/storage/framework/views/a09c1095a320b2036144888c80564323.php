<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Start Header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<?php
    $type = App\Constants\GlobalConst::SETUP_PAGE;
    $menues = DB::table('setup_pages')
            ->where('status', 1)
            ->where('type', Str::slug($type))
            ->get();
?>

<header class="header-section position-sticky">
    <div class="header">
        <div class="header-bottom-area">
            <div class="container custom-container">
                <div class="header-menu-content">
                    <nav class="navbar navbar-expand-xl p-0">
                        <a class="site-logo sidebar-main-logo site-title" href="<?php echo e(setRoute('index')); ?>">
                            <img  src="<?php echo e(get_logo($basic_settings)); ?>"  data-white_img="<?php echo e(get_logo($basic_settings,'white')); ?>"
                                data-dark_img="<?php echo e(get_logo($basic_settings,'dark')); ?>"
                                alt="site-logo">
                        </a>
                        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                            <span class="fas fa-bars"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav main-menu m-auto">
                                <?php
                                    $current_url = URL::current();
                                ?>
                                <?php $__currentLoopData = $menues; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <?php if($item->slug != 'contact'): ?>
                                        <?php
                                            $title = json_decode($item->title);
                                        ?>
                                        <li class="nav-item dropdown">
                                            <a href="<?php echo e(url($item->url)); ?>" class="<?php if($current_url == url($item->url)): ?> active <?php endif; ?>">
                                                <?php echo e(__($title->title)); ?>

                                            </a>
                                        </li>
                                    <?php endif; ?>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                            </ul>


                            <div class="navbar-right">
                                <ul>
                                    <?php $__currentLoopData = $menues; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                        <?php if($item->slug == 'contact'): ?>
                                            <?php
                                                $title = json_decode($item->title);
                                            ?>
                                            <li class="nav-item">
                                                <a href="<?php echo e(url($item->url)); ?>" class=" help-btn <?php if($current_url == url($item->url)): ?> active <?php endif; ?>">
                                                    <?php echo e(__("Help")); ?>

                                                </a>
                                            </li>
                                        <?php endif; ?>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

                                </ul>
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
                                <!-- Dark Mode Toggle -->
                                <div class="dark-light header-version-bar" title="Version">
                                    <i class="las la-sun"></i>
                                    <i class="las la-moon" style="display: none;"></i>
                                </div>

                                <div class="header-action">
                                    <?php if(auth()->guard()->check()): ?>
                                        <?php if(auth()->user()->email_verified == 0): ?>
                                            <a href="<?php echo e(setRoute('user.login')); ?>" class="btn--base btn"><?php echo e(__("Log In")); ?></a>
                                        <?php else: ?>
                                            <a href="<?php echo e(setRoute('user.dashboard')); ?>" class="btn--base btn-active"><?php echo e(__("Dashboard")); ?></a>
                                        <?php endif; ?>
                                    <?php else: ?>
                                        <a href="<?php echo e(setRoute('user.login')); ?>" class="btn--base btn"><?php echo e(__("Log In")); ?></a>
                                        <a href="<?php echo e(setRoute('user.register')); ?>" class="btn--base btn-active"><?php echo e(__("Sign Up")); ?></a>
                                    <?php endif; ?>
                                </div>

                            </div>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</header>
<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    End Header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/partials/header.blade.php ENDPATH**/ ?>