import 'package:get/get.dart';
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";

import "package:stripcard/views/profile/controller/update_profile_controller.dart";

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashBoardController());
    Get.put(UpdateProfileController());
  }
}
