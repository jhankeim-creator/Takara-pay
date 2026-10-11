import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/kyc/controller/kyc_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

File? imageFile;

class KycImageWidget extends StatelessWidget {
  KycImageWidget({Key? key, required this.labelName, required this.fieldName})
      : super(key: key);

  final controller = Get.put(KycController());
  final String labelName;
  final String fieldName;

  Future pickImage(imageSource) async {
    try {
      final image =
          await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
      if (image == null) return;

      imageFile = File(image.path);

      if (controller.listFieldName.isNotEmpty) {
        if (controller.listFieldName.contains(fieldName)) {
          int itemIndex = controller.listFieldName.indexOf(fieldName);
          controller.listFieldName[itemIndex] = fieldName;
          controller.listImagePath[itemIndex] = imageFile!.path;
        } else {
          controller.listImagePath.add(imageFile!.path);
          controller.listFieldName.add(fieldName);
        }
      } else {
        controller.listImagePath.add(imageFile!.path);
        controller.listFieldName.add(fieldName);
      }

      Get.back();
      CustomSnackBar.success('$labelName Added');
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          builder: (context) => imagePickerBottomSheetWidget(context),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.line2, width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.file_upload_outlined,
              color: AppColors.text3,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                labelName,
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imagePickerBottomSheetWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labelName,
              style: AppTextStyles.h2.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _pickerOption(
                    icon: Icons.image_outlined,
                    label: 'Gallery',
                    onTap: () => pickImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _pickerOption(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    onTap: () => pickImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.line2, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.accent),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
            ),
          ],
        ),
      ),
    );
  }
}
