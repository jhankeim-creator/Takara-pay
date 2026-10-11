<?php if(isset($label) && $label != false): ?>
    <?php
        $for_id = preg_replace('/[^A-Za-z0-9\-]/', '', Str::lower($label));
    ?>
    <label for="<?php echo e($for_id ?? ""); ?>"><?php echo $label ?? ""; ?></label>
<?php endif; ?>
<input type="file" class="<?php echo e($class ?? ""); ?>" name="<?php echo e($name ?? ""); ?>" accept="<?php echo e($accept ?? "image/*"); ?>"
    <?php if(isset($old_files) && $old_files != ""): ?>
        data-preview-name= "<?php echo e($old_files); ?>"
    <?php endif; ?>
    <?php if(isset($old_files_path) && $old_files_path != ""): ?>
        data-preview-path="<?php echo e($old_files_path); ?>"
    <?php endif; ?>
<?php echo e($attribute ?? ""); ?> id="<?php echo e($for_id ?? ""); ?>">

<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/components/form/input-file.blade.php ENDPATH**/ ?>