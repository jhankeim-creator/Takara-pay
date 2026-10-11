import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/language/strings.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

class CustomSnackBar {
  static success(String message) {
    return _show(
      title: Strings.successSnack,
      message: message,
      icon: Icons.check_circle,
      iconColor: AppColors.accent,
    );
  }

  static error(String message) {
    return _show(
      title: Strings.alert,
      message: message,
      icon: Icons.error_outline,
      iconColor: AppColors.danger,
    );
  }

  static _show({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    final lang = Get.find<LanguageController>();
    return Get.snackbar(
      lang.getTranslation(title),
      lang.getTranslation(message),
      titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              lang.getTranslation(message),
              style: AppTextStyles.body.copyWith(color: AppColors.bg),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.text,
      colorText: AppColors.bg,
      isDismissible: true,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: AppRadius.lg,
      margin: const EdgeInsets.all(12),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 350),
    );
  }
}
