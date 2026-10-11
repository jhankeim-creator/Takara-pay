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
    ], 'active' => __("Languages")], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php $__env->stopSection(); ?>

<?php $__env->startSection('content'); ?>
    <div class="table-area">
        <div class="table-wrapper">
            <?php echo $__env->renderUnless($languages->where("status",1)->count(),'admin.components.alerts.warning',['message' => "There is no default language in your system. System will automatically select English as a default language."], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1])); ?>
            <div class="table-header">
                <h5 class="title"><?php echo e(__($page_title)); ?></h5>
                <div class="table-btn-area">
                    <?php echo $__env->make('admin.components.link.add-default',[
                        'href'          => "#language-add",
                        'class'         => "py-2 px-4 modal-btn",
                         'text'          => __("Add New"),
                        'permission'    => "admin.languages.store",
                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    <?php echo $__env->make('admin.components.link.custom',[
                        'href'          => "#language-import",
                        'class'         => "btn--base py-2 px-4 bg--info modal-btn",
                        'icon'          => "fas fa-upload me-1",
                        'text'          => __("Import"),
                        'permission'    => "admin.languages.import",
                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    <?php if(language_file_exists()): ?>
                        <?php echo $__env->make('admin.components.link.custom',[
                            'text'          => __("Download"),
                            'icon'          => "fas fa-download me-1",
                            'permission'    => "admin.languages.download",
                            'href'          => setRoute('admin.languages.download'),
                            'class'         => "btn--base py-2 px-4 bg--primary",
                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                    <?php endif; ?>
                </div>
            </div>
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th><?php echo e(__("Name")); ?></th>
                            <th><?php echo e(__("Code")); ?></th>
                            <th><?php echo e(__("Direction")); ?></th>
                            <th><?php echo e(__("Status")); ?></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php $__empty_1 = true; $__currentLoopData = $languages; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $item): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <tr data-item="<?php echo e($item->editData); ?>">
                                <td><?php echo e($item->name); ?></td>
                                <td><?php echo e($item->code); ?></td>
                                <td><?php echo e(Str::upper($item->dir)); ?></td>
                                <td>
                                    <?php echo $__env->make('admin.components.form.switcher',[
                                        'name'          => 'status',
                                        'value'         => $item->status,
                                        'options'       => [__('Default') => 1,__('Selectable') => 0],
                                        'onload'     => true,
                                        'data_target'   => $item->id,
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                </td>
                                <td>
                                    <?php echo $__env->make('admin.components.link.info-default',[
                                        'href'          => setRoute('admin.languages.info',$item->code),
                                        'permission'    => "admin.languages.info",
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    <?php echo $__env->make('admin.components.link.edit-default',[
                                        'class'         => "edit-modal-button",
                                        'permission'    => "admin.languages.update",
                                    ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    <?php if(language_const()::NOT_REMOVABLE != $item->code): ?>
                                        <?php echo $__env->make('admin.components.link.delete-default',[
                                            'class'         => "delete-modal-button",
                                            'permission'    => "admin.languages.delete",
                                        ], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <?php echo $__env->make('admin.components.alerts.empty',['colspan' => 4], array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    
    <?php echo $__env->make('admin.components.modals.language.add', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>

    
    <?php echo $__env->make('admin.components.modals.language.edit', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>

    
    <?php echo $__env->make('admin.components.modals.language.import',compact("languages"), array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>

<?php $__env->stopSection(); ?>

<?php $__env->startPush('script'); ?>
    <script>
        $(".delete-modal-button").click(function() {
            var oldData = JSON.parse($(this).parents("tr").attr("data-item"));

            var actionRoute =  "<?php echo e(setRoute('admin.languages.delete')); ?>";
            var target      = oldData.id;
            var message     = '<?php echo e(__("Are you sure to delete this language?")); ?>';

            openDeleteModal(actionRoute,target,message);
        });
        // Switcher
        switcherAjax("<?php echo e(setRoute('admin.languages.status.update')); ?>");
    </script>
<?php $__env->stopPush(); ?>

<?php echo $__env->make('admin.layouts.master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/sections/language/index.blade.php ENDPATH**/ ?>