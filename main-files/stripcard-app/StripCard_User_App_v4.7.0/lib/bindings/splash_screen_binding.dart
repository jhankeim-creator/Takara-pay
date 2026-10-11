import 'package:get/get.dart';

import "package:stripcard/views/splash/controller/splash_screen_controller.dart";

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
