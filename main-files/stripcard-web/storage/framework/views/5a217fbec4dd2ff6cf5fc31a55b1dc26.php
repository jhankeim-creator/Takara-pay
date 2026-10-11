<?php $__env->startSection('content'); ?>

    <?php
        $cross_icon = '<div class="doc-loader text-center">
                        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 130.2 130.2">
                            <circle class="path circle" fill="none" stroke="#d63384" stroke-width="6" stroke-miterlimit="10" cx="65.1" cy="65.1" r="62.1"/>
                            <line class="path line" fill="none" stroke="#d63384" stroke-width="6" stroke-linecap="round" stroke-miterlimit="10" x1="34.4" y1="37.9" x2="95.8" y2="92.3"/>
                            <line class="path line" fill="none" stroke="#d63384" stroke-width="6" stroke-linecap="round" stroke-miterlimit="10" x1="95.8" y1="38" x2="34.4" y2="92.2"/>
                        </svg>
                    </div>';
        
        $check_icon = '<div class="doc-loader text-center">
                        <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 130.2 130.2">
                            <circle class="path circle" fill="none" stroke="#328AF1" stroke-width="6" stroke-miterlimit="10" cx="65.1" cy="65.1" r="62.1"/>
                            <polyline class="path check" fill="none" stroke="#328AF1" stroke-width="6" stroke-linecap="round" stroke-miterlimit="10" points="100.2,40.2 51.5,88.8 29.8,67.5 "/>
                        </svg>
                    </div>';
    ?>

    <div class="doc-inner">
        <div class="doc-wrapper w-100">
            <h2 class="inner-title"><?php echo e(__("Project Installation Server")); ?> <span><?php echo e(__("Requirements")); ?></span></h2>
            <h4 class="mt-10 text--white fw-normal">PHP Version</h4>
            <ul class="doc-list">
                <li>
                    <div class="<?php echo e(($requirements['php']['version']['status'] == false) ? 'text-danger' : 'text-success'); ?> fw-bold">
                        <?php echo e($requirements['php']['version']['server_v']); ?>

                    </div>

                    <?php if($requirements['php']['version']['status'] == true): ?>
                        <?php echo $check_icon; ?>

                    <?php else: ?>
                        <?php echo $cross_icon; ?>

                    <?php endif; ?>

                </li>
                <?php if($requirements['php']['version']['status'] == false): ?>
                    <div class="text-sm text-danger"><?php echo e($requirements['php']['version']['message']); ?></div>
                <?php endif; ?>

            </ul>

            
            <h4 class="mt-10 text--white fw-normal">PHP Extensions</h4>
            <ul class="doc-list">
                <?php $__currentLoopData = $requirements['php']['extensions']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <li>
                        <div class="<?php echo e(($item['status'] == false) ? 'text-danger' : 'text-success'); ?> fw-bold">
                            <?php echo e($item['name']); ?>

                        </div>

                        <?php if($item['status'] == true): ?>
                            <?php echo $check_icon; ?>

                        <?php else: ?>
                            <?php echo $cross_icon; ?>

                        <?php endif; ?>

                    </li>
                    <?php if($item['status'] == false): ?>
                        <div class="text-sm text-danger"><?php echo e($item['message']); ?></div>
                    <?php endif; ?>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </ul>

            
            <?php if(count($requirements['server']) > 0): ?>
                <h4 class="mt-10 text--white fw-normal">Server Information</h4>
                <ul class="doc-list">
                    <?php $__currentLoopData = $requirements['server']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                        <li>
                            <div class="<?php echo e(($item['status'] == false) ? 'text-danger' : 'text-success'); ?> fw-bold">
                                <?php echo e($item['name']); ?>

                            </div>

                            <?php if($item['status'] == true): ?>
                                <?php echo $check_icon; ?>

                            <?php else: ?>
                                <?php echo $cross_icon; ?>

                            <?php endif; ?>

                        </li>
                        <?php if($item['status'] == false): ?>
                            <div class="text-sm text-danger"><?php echo e($item['message']); ?></div>
                        <?php endif; ?>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                </ul>
            <?php endif; ?>

            

            <div class="doc-btn mt-20 d-flex align-items-center justify-content-between gap-3">
                <a href="<?php echo e(route('project.install.welcome')); ?>" class="btn--base bg--primary">&#8920; &nbsp; &nbsp; <?php echo e(__("Back")); ?></a>
                <a href="<?php echo e(route('project.install.validation.form')); ?>" class="btn--base"><?php echo e(__("Next")); ?> &nbsp; &nbsp; &#8921;</a>
            </div>
        </div>

    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('installer.layouts.app', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/installer/src/views/installer/pages/requirements.blade.php ENDPATH**/ ?>