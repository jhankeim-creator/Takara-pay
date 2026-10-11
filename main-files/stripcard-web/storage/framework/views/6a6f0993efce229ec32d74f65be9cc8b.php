<?php $attributes ??= new \Illuminate\View\ComponentAttributeBag;

$__newAttributes = [];
$__propNames = \Illuminate\View\ComponentAttributeBag::extractPropNames(([
    'site_key',
    'extension',
    'position'  => 'start',
]));

foreach ($attributes->all() as $__key => $__value) {
    if (in_array($__key, $__propNames)) {
        $$__key = $$__key ?? $__value;
    } else {
        $__newAttributes[$__key] = $__value;
    }
}

$attributes = new \Illuminate\View\ComponentAttributeBag($__newAttributes);

unset($__propNames);
unset($__newAttributes);

foreach (array_filter(([
    'site_key',
    'extension',
    'position'  => 'start',
]), 'is_string', ARRAY_FILTER_USE_KEY) as $__key => $__value) {
    $$__key = $$__key ?? $__value;
}

$__defined_vars = get_defined_vars();

foreach ($attributes->all() as $__key => $__value) {
    if (array_key_exists($__key, $__defined_vars)) unset($$__key);
}

unset($__defined_vars, $__key, $__value); ?>

<?php
    $position = match($position){
        'center'    => "justify-content-center",
        'start'     => "justify-content-start",
        'end'       => "justify-content-end",
    };
?>

<?php if($extension->status ?? false): ?>

    <div class="mb-4 d-flex <?php echo e($position); ?>">
        <div class="g-recaptcha" data-sitekey="<?php echo e($site_key); ?>" data-theme="light" data-callback="googleV2CaptchaCallback"></div>
    </div>

    <?php if (! $__env->hasRenderedOnce('0bdf9225-3750-4fc1-8dd3-40d47c411d01')): $__env->markAsRenderedOnce('0bdf9225-3750-4fc1-8dd3-40d47c411d01');
$__env->startPush('css'); ?>
        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <?php $__env->stopPush(); endif; ?>

    <?php $__env->startPush('script'); ?>
        <script>
            function googleV2CaptchaCallback(token){
                // handle token
            }
        </script>
    <?php $__env->stopPush(); ?>
<?php endif; ?>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/components/security/google-recaptcha-field.blade.php ENDPATH**/ ?>