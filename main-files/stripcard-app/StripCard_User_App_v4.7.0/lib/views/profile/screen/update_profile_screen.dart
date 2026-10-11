import 'dart:io';

import 'package:flutter/services.dart';
import "package:stripcard/base/utils/language/language_controller.dart";
import 'package:image_picker/image_picker.dart';

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/views/app_settings/controller/app_settings_controller.dart";
import "package:stripcard/views/profile/controller/update_profile_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/error_state_widget.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/design_system/sc_shimmer.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";
import "package:stripcard/base/widgets/others/image_picker/image_picker.dart";

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final controller = Get.put(UpdateProfileController());
  final imgController = Get.put(InputImageController());
  final profileFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: Get.back,
        ),
        title: Text(
          Get.find<LanguageController>().getTranslation(Strings.profile),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading
              ? const SCFormSkeleton(fieldCount: 6, showHero: true)
              : controller.isLoaded
              ? _bodyWidget(context)
              : _errorState(),
        ),
      ),
    );
  }

  // Recoverable error instead of a red LateInitializationError crash when the
  // profile API fails (no network / server / API issue).
  Widget _errorState() {
    return ErrorStateWidget(
      title: Get.find<LanguageController>()
          .getTranslation(Strings.couldntLoadProfile),
      message: Get.find<LanguageController>()
          .getTranslation(Strings.checkConnectionAndRetryShort),
      retryLabel: Get.find<LanguageController>().getTranslation(Strings.retry),
      onRetry: controller.getUserProfileData,
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const BouncingScrollPhysics(),
      children: [
        _avatarWidget(context),
        const SizedBox(height: 16),
        _identityWidget(context),
        const SizedBox(height: 28),
        _inputWidget(context),
        const SizedBox(height: 28),
        _buttonWidget(context),
      ],
    );
  }

  // ── Profile photo with camera affordance ───────────────────────────────
  // Preserves the original image-pick logic: writes through `imageController`
  // (InputImageController) via setImagePath, and reads existing/default image
  // from the profile model + AppSettingsController.
  Widget _avatarWidget(BuildContext context) {
    return Center(
      child: Obx(() {
        final hasPicked = imageController.isImagePathSet.value;

        ImageProvider? provider;
        if (hasPicked) {
          provider = FileImage(File(imageController.imagePath.value));
        } else {
          final data = controller.userProfileModel.data;
          final userImage = data.user.userImage;
          final defaultImage =
              "${Get.find<AppSettingsController>().assetBaseUrl.value}/${data.defaultImage}";
          final url = data.imagePath.isNotEmpty ? userImage : defaultImage;
          provider = scImageProvider(url?.toString());
        }

        return SizedBox(
          width: 104,
          height: 104,
          child: Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.line, width: 1),
                  image: provider != null
                      ? DecorationImage(image: provider, fit: BoxFit.cover)
                      : null,
                ),
                alignment: Alignment.center,
                child: provider == null
                    ? Image.asset(
                        Assets.clipart.user.path,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _showImageSourceSheet(context),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: AppColors.accentInk,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Image picker — preserves source selection and writes via imageController.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 40,
        maxHeight: 600,
        maxWidth: 600,
      );
      if (image == null) return;
      imageController.setImagePath(File(image.path).path);
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _SourceTile(
                      icon: Icons.photo_camera_outlined,
                      onTap: () {
                        Get.back();
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceTile(
                      icon: Icons.image_outlined,
                      onTap: () {
                        Get.back();
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Name + email summary ────────────────────────────────────────────────
  Widget _identityWidget(BuildContext context) {
    return Column(
      children: [
        Text(
          "${controller.firstNameController.text} ${controller.lastNameController.text}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.h2.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 4),
        Text(
          controller.emailController.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }

  // ── Form fields ─────────────────────────────────────────────────────────
  Widget _inputWidget(BuildContext context) {
    return Form(
      key: profileFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.firstName,
                  ),
                  hint: Get.find<LanguageController>().getTranslation(
                    Strings.enterFirstName,
                  ),
                  controller: controller.firstNameController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.lastName,
                  ),
                  hint: Get.find<LanguageController>().getTranslation(
                    Strings.enterLastName,
                  ),
                  controller: controller.lastNameController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            Get.find<LanguageController>().getTranslation(Strings.country),
            style: AppTextStyles.label.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: 6),
          _countryField(),
          const SizedBox(height: 18),
          SCTextField(
            label: Get.find<LanguageController>().getTranslation(Strings.phone),
            hint:
                '${Get.find<LanguageController>().getTranslation(Strings.enter)} ${Get.find<LanguageController>().getTranslation(Strings.phone)}',
            keyboardType: TextInputType.number,
            controller: controller.phoneNumberController,
            prefixIcon: Obx(
              () => Text(
                '+${controller.selectedCountryCode.value.replaceAll('+', '')}',
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.address,
                  ),
                  hint:
                      '${Get.find<LanguageController>().getTranslation(Strings.enter)} ${Get.find<LanguageController>().getTranslation(Strings.address)}',
                  controller: controller.addressController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.selectCity,
                  ),
                  hint: Get.find<LanguageController>().getTranslation(
                    Strings.enterSelectCity,
                  ),
                  controller: controller.cityController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.state,
                  ),
                  hint:
                      '${Get.find<LanguageController>().getTranslation(Strings.enter)} ${Get.find<LanguageController>().getTranslation(Strings.state)}',
                  controller: controller.stateController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SCTextField(
                  label: Get.find<LanguageController>().getTranslation(
                    Strings.zipCode,
                  ),
                  hint: Get.find<LanguageController>().getTranslation(
                    Strings.enterZipCode,
                  ),
                  keyboardType: TextInputType.number,
                  controller: controller.zipCodeController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Country dropdown styled to match SCTextField surface.
  Widget _countryField() {
    return Obx(
      () => Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.line2, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            value: null,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
            ),
            hint: Text(
              controller.selectedCountry.value,
              style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            items: controller.userProfileModel.data.countries
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.name,
                      style: AppTextStyles.body.copyWith(color: AppColors.text),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              controller.selectedCountry.value = value!.name;
              controller.selectedCountryCode.value = value.mobileCode;

              print(controller.selectedCountry.value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Obx(
      () => SCPrimaryButton(
        label: Get.find<LanguageController>().getTranslation(Strings.submit),
        loading: controller.isUpdateLoading,
        onPressed: () {
          if (profileFormKey.currentState!.validate()) {
            if (controller.imageController.isImagePathSet.value) {
              controller.profileUpdateWithImageProcess();
            } else {
              controller.profileUpdateWithOutImageProcess();
            }
          }
        },
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          height: 72,
          alignment: Alignment.center,
          child: Icon(icon, size: 26, color: AppColors.text),
        ),
      ),
    );
  }
}
