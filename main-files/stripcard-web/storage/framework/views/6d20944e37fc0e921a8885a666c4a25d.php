<?php if(isset($label)): ?>
    <?php
        $for_id = preg_replace('/[^A-Za-z0-9\-]/', '', strip_tags(Str::lower($label)));
    ?>
    <label for="<?php echo e($for_id ?? ""); ?>"><?php echo $label; ?> <?php if(isset($required)): ?> <span class="text--base">*</span> <?php endif; ?> </label>
<?php endif; ?>

<input type="<?php echo e($type ?? "text"); ?>" placeholder="<?php echo e($placeholder ?? __("Write Here")); ?>" name="<?php echo e($name ?? ""); ?>" class="form--control <?php echo e($class ?? ""); ?> <?php $__errorArgs = [$name ?? false];
$__bag = $errors->getBag($__errorArgs[1] ?? 'default');
if ($__bag->has($__errorArgs[0])) :
if (isset($message)) { $__messageOriginal = $message; }
$message = $__bag->first($__errorArgs[0]); ?> is-invalid <?php unset($message);
if (isset($__messageOriginal)) { $message = $__messageOriginal; }
endif;
unset($__errorArgs, $__bag); ?>" <?php echo e($attribute ?? ""); ?> value="<?php echo e($value ?? ""); ?>" <?php if(isset($data_limit)): ?>
    data-limit = <?php echo e($data_limit); ?>

<?php endif; ?> <?php if(isset($required)): ?>
    required
<?php endif; ?>>

<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/admin/components/form/input.blade.php ENDPATH**/ ?>