<!-- jquery -->
<script src="<?php echo e(asset('frontend/js/jquery-3.6.0.js')); ?>"></script>
<!-- bootstrap js -->
<script src="<?php echo e(asset('frontend/js/bootstrap.bundle.js')); ?>"></script>
<!-- swipper js -->
<script src="<?php echo e(asset('frontend/js/swiper.js')); ?>"></script>

<script src="<?php echo e(asset('frontend/js/lightcase.js')); ?>"></script>
<!-- odometer js -->
<script src="<?php echo e(asset('frontend/js/odometer.js')); ?>"></script>
<!-- viewport js -->
<script src="<?php echo e(asset('frontend/js/viewport.jquery.js')); ?>"></script>

<script src="<?php echo e(asset('frontend/js/aos.js')); ?>"></script>

<script src="<?php echo e(asset('frontend/js/smoothscroll.js')); ?>"></script>

<script src="<?php echo e(asset('backend/js/select2.js')); ?>"></script>

<script src="<?php echo e(asset('backend/library/popup/jquery.magnific-popup.js')); ?>"></script>

<!-- nice select js -->
<script src="<?php echo e(asset('frontend/js/jquery.nice-select.js')); ?>"></script>

<script src="https://www.google.com/recaptcha/api.js" async defer></script>

<script>
     var fileHolderAfterLoad = {};
 </script>

 <script src="https://cdn.appdevs.cloud/fileholder/v1.0/js/fileholder-script.js" type="module"></script>
 <script type="module">
     import {
         fileHolderSettings
     } from "https://cdn.appdevs.cloud/fileholder/v1.0/js/fileholder-settings.js";
     import {
         previewFunctions
     } from "https://cdn.appdevs.cloud/fileholder/v1.0/js/fileholder-script.js";

     var inputFields = document.querySelector(".file-holder");
     fileHolderAfterLoad.previewReInit = function(inputFields) {
         previewFunctions.previewReInit(inputFields)
     };

     fileHolderSettings.urls.uploadUrl = "<?php echo e(setRoute('fileholder.upload')); ?>";
     fileHolderSettings.urls.removeUrl = "<?php echo e(setRoute('fileholder.remove')); ?>";
 </script>

 <script>
     function fileHolderPreviewReInit(selector) {
         var inputField = document.querySelector(selector);
         fileHolderAfterLoad.previewReInit(inputField);
     }
 </script>

<!-- main -->
<script src="<?php echo e(asset('frontend/js/darkmode.js')); ?>"></script>



<script src="<?php echo e(asset('frontend/js/main.js')); ?>"></script>

<script>
    $(".langSel").on("change", function() {
        window.location.href = "<?php echo e(route('index')); ?>/change/" + $(this).val();
    });
</script>


<?php echo $__env->make('admin.partials.notify', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/partials/footer-asset.blade.php ENDPATH**/ ?>