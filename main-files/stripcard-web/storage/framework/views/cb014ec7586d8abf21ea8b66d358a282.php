<!-- favicon -->
<link rel="shortcut icon" href="<?php echo e(get_fav($basic_settings)); ?>" type="image/x-icon">
<!-- fontawesome css link -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/fontawesome-all.css')); ?>">
<!-- bootstrap css link -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/bootstrap.css')); ?>">
<!-- swipper css link -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/swiper.css')); ?>">
<!-- odometer css link -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/lightcase.css')); ?>">

<link rel="stylesheet" href="<?php echo e(asset('frontend/css/aos.css')); ?>">

<link rel="stylesheet" href="<?php echo e(asset('frontend/css/odometer.css')); ?>">

<link rel="stylesheet" href="<?php echo e(asset('frontend/css/animate.css')); ?>">
<!-- line-awesome-icon css -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/line-awesome.css')); ?>">
<!-- animate.css -->
<link rel="stylesheet" href="<?php echo e(asset('backend/library/popup/magnific-popup.css')); ?>">

<link rel="stylesheet" href="<?php echo e(asset('backend/css/select2.css')); ?>">

<!-- nice select css -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/nice-select.css')); ?>">
<!-- Fileholder CSS CDN -->
<link rel="stylesheet" href="https://cdn.appdevs.cloud/fileholder/v1.0/css/fileholder-style.css" type="text/css">
<!-- main style css link -->
<link rel="stylesheet" href="<?php echo e(asset('frontend/css/style.css')); ?>">

<?php
    $color = @$basic_settings->base_color ?? '#000000';

?>

<style>
    :root {
        --primary-color: <?php echo e($color); ?>;
    }
</style>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/partials/header-asset.blade.php ENDPATH**/ ?>