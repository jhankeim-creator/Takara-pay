
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:TAKARA PAY/base/utils/responsive_layout.dart";
import "package:TAKARA PAY/views/kyc/controller/kyc_controller.dart";
import "package:TAKARA PAY/views/kyc/screen/kyc_mobile_screen_layout.dart";


class KycScreen extends StatelessWidget {
  KycScreen({Key? key}) : super(key: key);
  final controller = Get.put(KycController());

  @override
  Widget build(BuildContext context) {
    // mobile screen layout
    return ResponsiveLayout(
      mobileScaffold: KycMobileScreenLayout(
        controller: controller,
      ),
    );
  }
}
