<?php
    $lang               = selectedLang();
    $system_default     = $default_language_code;
    $banner_slug        = Illuminate\Support\Str::slug(App\Constants\SiteSectionConst::HOME_BANNER);
    $banner             = App\Models\Admin\SiteSections::getData( $banner_slug)->first();
?>

<section class="banner-section" id="home">
    <div class="banner-element">
        <div class="banner-element-one">
        </div>
        <div class="banner-element-two">
        </div>
    </div>
    <div class="container">
        <div class="row align-items-center mb-30-none">
            <div class="col-xl-6 col-lg-6 mb-30">
                <div class="banner-content">
                    <?php
                        $heading = explode(' ', $banner->value->language->$lang->heading ?? $banner->value->language->$system_default->heading);
                    ?>

                    <span class="title-badge"></span>
                    <h5 class="sub-title"><span><?php echo e(__("Welcome To")); ?> <?php echo e($basic_settings->site_name); ?> !</span></h5>
                    <h1 class="title"><?php echo e(@$heading[0]); ?> <?php echo e(@$heading[1]); ?> <?php echo e(@$heading[2]); ?> <?php echo e(@$heading[4]); ?>  <span class="text--base"> <?php echo e(@$heading[5]); ?>  <?php echo e(@$heading[6]); ?></span>  <?php echo e(@$heading[7]); ?></h1>
                    <p><?php echo e(__($banner->value->language->$lang->sub_heading ?? $banner->value->language->$system_default->sub_heading)); ?></p>

                    <div class="banner-btn">
                        <a href="<?php echo e(setRoute('user.dashboard')); ?>" class="btn--base"><?php echo e(__("Apply Virtual Card")); ?></a>
                    </div>
                </div>
            </div>
            <div class="col-xl-6 col-lg-6 mb-30">
                <div class="banner-thumb">
                    <img src="<?php echo e(get_image(@$banner->value->images->banner_image,'site-section')); ?>" alt="element">
                </div>
            </div>
        </div>
    </div>
</section>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/frontend/sections/home-banner.blade.php ENDPATH**/ ?>