import 'package:get/get.dart';
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/service/force_update_service.dart";
import "package:stripcard/routes/routes.dart";
import "package:stripcard/views/splash/controller/navigator_plug.dart";

class SplashController extends GetxController {
  final navigatorPlug = NavigatorPlug();

  @override
  void onReady() {
    super.onReady();
    // Check for a forced app update on every launch (Android: Play in-app
    // update). Fire-and-forget so it never blocks splash navigation; if an
    // update is required, Play's full-screen flow takes over.
    ForceUpdateService.check();
    navigatorPlug.startListening(
      seconds: 3,
      onChanged: () {
        LocalStorage.isLoggedIn()
            ? Get.offAndToNamed(Routes.bottomNavBarScreen)
            : Get.offAndToNamed(
                LocalStorage.isOnBoardDone()
                    ? Routes.signInScreen
                    : Routes.onboardScreen,
              );
      },
    );
  }
 
 
  @override
  void onClose() {
    navigatorPlug.stopListening();
    super.onClose();
  }
}
