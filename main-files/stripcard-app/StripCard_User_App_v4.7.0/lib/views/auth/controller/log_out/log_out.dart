import "package:stripcard/base/utils/basic_screen_import.dart";

import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/services/api_services.dart";

class LogOutController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Future<void> logOutProcess() async {
    _isLoading.value = true;
    update();

    // Best-effort: notify the backend, but never let a failure block logout.
    try {
      await ApiServices.logOutApi();
    } catch (onError) {
      log.e(onError);
    } finally {
      // ALWAYS clear the local session so the token is removed even when the
      // server is down / the API fails — the next app launch will then route
      // to the sign-in screen instead of auto-logging in.
      await LocalStorage.logout();
      _isLoading.value = false;
      update();
      Get.offAllNamed(Routes.signInScreen);
    }
  }
}
