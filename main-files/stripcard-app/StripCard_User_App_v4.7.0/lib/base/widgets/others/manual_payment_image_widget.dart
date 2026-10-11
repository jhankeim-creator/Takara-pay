import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/deposit/controller/manual_gateway_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";

File? imageFile;

class ManualPaymentImageWidget extends StatelessWidget {
  ManualPaymentImageWidget(
      {Key? key, required this.labelName, required this.fieldName})
      : super(key: key);

  final controller = Get.put(ManualPaymentController());
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
          builder: (context) => imagePickerBottomSheetWidget(context),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(width: 1, color: AppColors.line2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.file_upload_outlined,
              size: 20,
              color: AppColors.accent,
            ),
            const SizedBox(width: 10),
            Flexible(
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

  imagePickerBottomSheetWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Row(
          children: [
            Expanded(
              child: _pickerOption(
                icon: Icons.image_outlined,
                label: 'Gallery',
                onTap: () => pickImage(ImageSource.gallery),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _pickerOption(
                icon: Icons.photo_camera_outlined,
                label: 'Camera',
                onTap: () => pickImage(ImageSource.camera),
              ),
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
    return Material(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColors.accent),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.label.copyWith(color: AppColors.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
