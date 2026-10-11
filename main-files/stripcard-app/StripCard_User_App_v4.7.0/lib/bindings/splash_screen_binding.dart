import 'package:get/get.dart';

import "package:TAKARA PAY/views/splash/controller/splash_screen_controller.dart";

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
