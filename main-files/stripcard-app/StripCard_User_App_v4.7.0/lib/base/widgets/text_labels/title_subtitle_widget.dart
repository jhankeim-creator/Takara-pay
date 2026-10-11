import 'package:get/get.dart';
import "package:TAKARA PAY/base/utils/custom_color.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_heading4_widget.dart";
import 'package:flutter/material.dart';

import "package:TAKARA PAY/base/utils/dimensions.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_heading1_widget.dart";

class TitleSubTitleWidget extends StatelessWidget {
  const TitleSubTitleWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.crossAxisAlignment = CrossAxisAlignment.start})
      : super(key: key);
  final String title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        TitleHeading1Widget(
          text: title,
          textAlign: TextAlign.center,
          fontSize: Dimensions.headingTextSize1,
          fontWeight: FontWeight.w700,
          color: Get.isDarkMode
              ? CustomColor.primaryLightTextColor
              : CustomColor.primaryDarkTextColor,
          padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.3),
        ),
        TitleHeading4Widget(
          text: subtitle,
          textAlign: TextAlign.center,
          fontSize: Dimensions.headingTextSize4,
          fontWeight: FontWeight.w700,
          color: Get.isDarkMode
              ? CustomColor.primaryLightTextColor
              : CustomColor.primaryDarkTextColor,
        ),
      ],
    );
  }
}
