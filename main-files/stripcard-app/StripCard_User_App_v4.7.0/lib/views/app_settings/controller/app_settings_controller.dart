import 'dart:async';

import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

import "package:TAKARA PAY/base/api/model/onboard/app_settings_model.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";

class AppSettingsController extends GetxController {
  // Reactive so the onboarding screen rebuilds the moment the admin-configured
  // slides arrive from /app-settings. `image` entries hold the FULL asset URL.
  final RxList<OnboardScreen> onboardScreen = <OnboardScreen>[].obs;
  var fiatPrecisionValue = 0.obs;
  var cryptoPrecisionValue = 0.obs;


  RxString assetBaseUrl = ''.obs;

  RxString splashImagePath = ''.obs;
  RxBool isVisible = false.obs;

  @override
  void onInit() {
    getSplashAndOnboardData().then((value) {
      Timer(const Duration(seconds: 4), () {
        isVisible.value = true;
      });
    });
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late AppSettingsModel _appSettingsModel;

  AppSettingsModel get appSettingsModel => _appSettingsModel;

  Future<AppSettingsModel> getSplashAndOnboardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.appSettingsApi().then((value) {
      _appSettingsModel = value!;

      assetBaseUrl.value = _appSettingsModel.data.assetBaseUrl;
      splashImagePath.value =
          "${assetBaseUrl.value}${_appSettingsModel.data.imagePath}/${_appSettingsModel.data.splashScreen.splashScreenImage}";

      LocalStorage.saveSplashImage(
          image:
              "${assetBaseUrl.value}${_appSettingsModel.data.imagePath}/${_appSettingsModel.data.splashScreen.splashScreenImage}");
      LocalStorage.emailVerificationSave(
          isEmailVerification:
              _appSettingsModel.data.basicSettingsData.emailVerification);

      LocalStorage.saveBasicImage(
          image:
              "${assetBaseUrl.value}${_appSettingsModel.data.logoImagePath}/${_appSettingsModel.data.allLogo.siteLogo}");

      print(LocalStorage.getSplashImage());

      // Rebuild the slide list: only admin-enabled slides, with the image
      // resolved to its full URL so the UI can render it directly.
      onboardScreen.clear();
      for (final element in _appSettingsModel.data.onboardScreen) {
        if (element.status != 1) continue;
        onboardScreen.add(
          OnboardScreen(
            id: element.id,
            title: element.title,
            subTitle: element.subTitle,
            image: element.image.trim().isEmpty
                ? ''
                : "${assetBaseUrl.value}${_appSettingsModel.data.imagePath}/${element.image}",
            status: element.status,
            createdAt: element.createdAt,
            updatedAt: element.updatedAt,
          ),
        );
      }

      fiatPrecisionValue.value = int.parse(
          _appSettingsModel.data.basicSettingsData.fiatPrecisionValue.toString());

      cryptoPrecisionValue.value = int.parse(
          _appSettingsModel.data.basicSettingsData.cryptoPrecisionValue.toString());

      print(fiatPrecisionValue.value);
      print(cryptoPrecisionValue.value);
      print(
          '---------------------------------------------------------------------------');
      print(
          '---------------------------------------------------------------------------');

      //save url link
      // var data = _appSettingsModel.data.p;
      // LocalStorage.savePrivacyPolicyLink(link: data.privacyPolicy);

      update();
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
    });
    _isLoading.value = false;
    update();
    return _appSettingsModel;
  }
}
