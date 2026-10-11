import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/custom_style.dart";

class TitleHeading3Widget extends StatelessWidget {
  const TitleHeading3Widget({
    Key? key,
    required this.text,
    this.textAlign,
    this.textOverflow,
    this.padding = paddingValue,
    this.opacity = 1.0,
    this.maxLines,
    this.fontSize,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final EdgeInsetsGeometry padding;
  final double opacity;
  final int? maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  static const paddingValue = EdgeInsets.all(0.0);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Opacity(
        opacity: opacity,
        child: Padding(
          padding: padding,
          child: Text(
                  Get.find<LanguageController>().getTranslation(text),
                  style: Get.isDarkMode
                      ? CustomStyle.darkHeading3TextStyle.copyWith(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: color)
                      : CustomStyle.lightHeading3TextStyle.copyWith(
                          fontSize: fontSize,
                          fontWeight: fontWeight,
                          color: color),
                  textAlign: textAlign,
                  overflow: textOverflow,
                  maxLines: maxLines,
                ),
        ),
      ),
    );
  }
}
