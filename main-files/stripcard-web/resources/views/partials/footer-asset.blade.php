<!-- jquery -->
<script src="{{ asset('frontend/js/jquery-3.6.0.js') }}"></script>
<!-- bootstrap js -->
<script src="{{ asset('frontend/js/bootstrap.bundle.js') }}"></script>
<!-- swipper js -->
<script src="{{ asset('frontend/js/swiper.js') }}"></script>

<script src="{{ asset('frontend/js/lightcase.js') }}"></script>
<!-- odometer js -->
<script src="{{ asset('frontend/js/odometer.js') }}"></script>
<!-- viewport js -->
<script src="{{ asset('frontend/js/viewport.jquery.js') }}"></script>

<script src="{{ asset('frontend/js/aos.js') }}"></script>

<script src="{{ asset('frontend/js/smoothscroll.js') }}"></script>

<script src="{{ asset('backend/js/select2.js') }}"></script>

<script src="{{ asset('backend/library/popup/jquery.magnific-popup.js') }}"></script>

<!-- nice select js -->
<script src="{{ asset('frontend/js/jquery.nice-select.js') }}"></script>

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

     fileHolderSettings.urls.uploadUrl = "{{ setRoute('fileholder.upload') }}";
     fileHolderSettings.urls.removeUrl = "{{ setRoute('fileholder.remove') }}";
 </script>

 <script>
     function fileHolderPreviewReInit(selector) {
         var inputField = document.querySelector(selector);
         fileHolderAfterLoad.previewReInit(inputField);
     }
 </script>

<!-- main -->
<script src="{{ asset('frontend/js/darkmode.js') }}"></script>



<script src="{{ asset('frontend/js/main.js') }}"></script>

<script>
    $(".langSel").on("change", function() {
        window.location.href = "{{ route('index') }}/change/" + $(this).val();
    });
</script>


@include('admin.partials.notify')
