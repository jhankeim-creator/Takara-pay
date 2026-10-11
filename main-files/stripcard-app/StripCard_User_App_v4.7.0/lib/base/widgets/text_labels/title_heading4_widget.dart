import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/custom_style.dart";

class TitleHeading4Widget extends StatelessWidget {
  const TitleHeading4Widget({
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
            style: (Get.isDarkMode
                ? CustomStyle.darkHeading4TextStyle
                : CustomStyle.lightHeading4TextStyle)
                .copyWith(
              fontSize: fontSize ?? 16.0,
              fontWeight: fontWeight ?? FontWeight.normal,
              color: color ?? (Get.isDarkMode
                  ? Colors.white
                  : Colors.black),
            ),
            textAlign: textAlign ?? TextAlign.start,
            overflow: textOverflow,
            maxLines: maxLines,
          ),
        ),
      ),
    );
  }
}
