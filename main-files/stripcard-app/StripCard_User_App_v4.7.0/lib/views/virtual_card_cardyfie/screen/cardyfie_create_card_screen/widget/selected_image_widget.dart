import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/others/image_picker_sheet.dart";

File? imageFile;

class SelectedImageWidget extends StatefulWidget {
  const SelectedImageWidget({
    super.key,
    required this.labelName,
    required this.fieldName,
    this.imageUrl,
    this.optionalLabel = '',
  });

  final String labelName;
  final String fieldName;
  final String? imageUrl;
  final String optionalLabel;

  @override
  State<SelectedImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<SelectedImageWidget> {
  final controller = Get.put(VirtualCardyfieCardController());

  Future pickImage(imageSource) async {
    try {
      final image = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 50,
      );
      if (image == null || !mounted) return;

      imageFile = File(image.path);

      if (controller.listFieldName.isNotEmpty) {
        if (controller.listFieldName.contains(widget.fieldName)) {
          int itemIndex = controller.listFieldName.indexOf(widget.fieldName);
          controller.listFieldName[itemIndex] = widget.fieldName;
          controller.listImagePath[itemIndex] = imageFile!.path;
        } else {
          controller.listImagePath.add(imageFile!.path);
          controller.listFieldName.add(widget.fieldName);
        }
      } else {
        controller.listImagePath.add(imageFile!.path);
        controller.listFieldName.add(widget.fieldName);
      }
      setState(() {
        controller.updateImageData(widget.fieldName, imageFile!.path);
      });
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImagePickerBottomSheet(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelName,
            style: AppTextStyles.label.copyWith(color: AppColors.text2),
          ),
          if (widget.optionalLabel != '')
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                widget.optionalLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.accent),
              ),
            ),
          const SizedBox(height: 6),

          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: RDottedLineBorder.all(
                color: AppColors.line,
                width: 1.2,
              ),
              image: controller.getImagePath(widget.fieldName) == null
                  ? (scImageProvider(widget.imageUrl) == null
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: scImageProvider(widget.imageUrl)!,
                        ))
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(controller.getImagePath(widget.fieldName) ?? ''),
                      ),
                    ),
            ),
            child: controller.getImagePath(widget.fieldName) == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          size: 20,
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.uploadImage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  _showImagePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.surface,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: ImagePickerSheet(
            fromCamera: () {
              pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
            fromGallery: () {
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
