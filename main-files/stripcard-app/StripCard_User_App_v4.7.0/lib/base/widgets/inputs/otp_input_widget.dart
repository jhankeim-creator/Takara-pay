import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import "package:TAKARA PAY/base/utils/custom_color.dart";
import "package:TAKARA PAY/base/utils/dimensions.dart";

class OtpInputTextFieldWidget extends StatelessWidget {
  const OtpInputTextFieldWidget({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      appContext: context,
      cursorColor: Theme.of(context).primaryColor,
      length: 6,
      obscureText: false,
      keyboardType: TextInputType.number,
      textStyle: TextStyle(
          color: Get.isDarkMode
              ? CustomColor.primaryLightTextColor
              : CustomColor.primaryDarkTextColor),
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(
          Dimensions.radius * 0.5,
        ),
        selectedColor: CustomColor.primaryTextColor,
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Get.isDarkMode
            ? CustomColor.primaryLightTextColor
            : CustomColor.primaryDarkTextColor,
        fieldHeight: 50,
        fieldWidth: 48,
        activeFillColor: CustomColor.transparent,
        borderWidth: 2,
      ),
      onChanged: (String value) {},
    );
  }
}
