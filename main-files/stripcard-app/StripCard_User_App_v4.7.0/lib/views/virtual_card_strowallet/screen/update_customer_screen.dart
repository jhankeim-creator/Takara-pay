import 'dart:io';

import 'package:image_picker/image_picker.dart';

import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/base/utils/data/strowallet_card_holder_options.dart";
import "package:TAKARA PAY/views/app_settings/controller/app_settings_controller.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/update_customer_kyc_controller.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/error_state_widget.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_network_image.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_shimmer.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";

// Static (not routed through Strings/.tr): the backend language dictionary
// doesn't carry this key, which would otherwise print the raw key instead of
// readable copy. Matches the existing convention in this file (see the
// 'Tap to select image' literal below).
const String _customerDetailsTitle = 'Customer Details';

/// Strowallet "Card Holder" form (latest API). Fixed text schema — no image
/// uploads. Backed by GET get/card-holder (prefill) + POST store/card-holder.
class UpdateCustomerKycScreen extends StatelessWidget {
  UpdateCustomerKycScreen({super.key});

  final controller = Get.put(UpdateCustomerKycController());

  String _t(String key) => languageSettingsController.getTranslation(key);

  String _idTypeLabel(String value) {
    switch (value) {
      case 'national_id':
        return _t(Strings.nationalId);
      case 'passport':
        return _t(Strings.passport);
      case 'drivers_license':
        return _t(Strings.driversLicense);
      default:
        return value;
    }
  }

  void _onSubmit() {
    controller.storeCardHolder().then((value) {
      if (value != null) {
        // Pop first, THEN surface the success snackbar on the destination —
        // avoids GetX popping the snackbar overlay instead of this page.
        Get.back(result: true);
        final msgs = value.message.success;
        CustomSnackBar.success(
          msgs.isNotEmpty
              ? msgs.first
              : _t(Strings.cardHolderSavedSuccessfully),
        );
      }
    });
  }

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
        title: Obx(
          () => Text(
            controller.isReadOnly
                ? _customerDetailsTitle
                : _t(Strings.createCardHolder),
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isCreateCardInfoLoading
              ? const SCFormSkeleton(showHero: true)
              // isLoaded is true ONLY for a successfully classified result
              // (exists or notCreated) — a genuine failure (network error,
              // 500, unexpected status, parse error) leaves it false so this
              // always falls to the retry state below, never the editable form.
              : controller.isLoaded
                  ? (controller.isReadOnly
                      ? _readOnlyBodyWidget(context)
                      : _bodyWidget(context))
                  : _errorState(),
        ),
      ),
    );
  }

  Widget _errorState() {
    return ErrorStateWidget(
      iconSize: 48,
      title: _t(Strings.couldntLoadCardHolder),
      message: _t(Strings.checkConnectionAndRetry),
      retryLabel: _t(Strings.retry),
      onRetry: controller.getCardHolder,
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      physics: const BouncingScrollPhysics(),
      children: [
        SCTextField(
          label: _t('name'),
          hint: _t(Strings.cardHolderSName),
          controller: controller.nameController,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SCTextField(
                label: _t(Strings.firstName),
                hint: _t(Strings.enterFirstName),
                controller: controller.firstNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                label: _t(Strings.lastName),
                hint: _t(Strings.enterLastName),
                controller: controller.lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SCTextField(
          label: _t(Strings.dateOfBirth),
          hint: 'YYYY-MM-DD',
          controller: controller.dobController,
          readOnly: true,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          onTap: () => _pickDob(context),
        ),
        const SizedBox(height: 16),
        _idTypeDropdown(context),
        const SizedBox(height: 16),
        SCTextField(
          label: _t(Strings.idNumber),
          hint: _t(Strings.idNumber),
          controller: controller.idNumberController,
        ),
        const SizedBox(height: 16),
        SCTextField(
          label: _t('email'),
          hint: _t('email'),
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        SCTextField(
          label: _t(Strings.address),
          hint: _t(Strings.address),
          controller: controller.line1Controller,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SCTextField(
                label: _t(Strings.city),
                hint: _t(Strings.city),
                controller: controller.cityController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                label: _t(Strings.state),
                hint: _t(Strings.state),
                controller: controller.stateController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SCTextField(
                label: _t(Strings.zipCode),
                hint: _t(Strings.zipCode),
                controller: controller.postalCodeController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _countryDropdown(context)),
          ],
        ),
        const SizedBox(height: 16),
        _accountPurposeDropdown(context),
        const SizedBox(height: 16),
        _employmentStatusDropdown(context),
        const SizedBox(height: 16),
        _occupationDropdown(context),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              width: 110,
              child: SCTextField(
                label: _t('phoneCode'),
                hint: '1',
                controller: controller.phoneCodeController,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SCTextField(
                label: _t(Strings.phone),
                hint: _t(Strings.phoneNumber),
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _idImageField(context),
        const SizedBox(height: 32),
        Obx(
          () => SCPrimaryButton(
            label: _t(Strings.submit),
            loading: controller.isConfirmLoading,
            onPressed: _onSubmit,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ─── Read-only "Customer Details" body ──────────────────────────────
  // Shown once GET get/card-holder confirms a card-holder already exists.
  // No TextFields/dropdowns/pickers — label/value rows only, matching the
  // existing read-only convention used by strowallet_details_screen.dart.

  static String _dv(String value) => value.trim().isEmpty ? '—' : value.trim();

  // Masks everything but the last 4 characters (or the last 1-2 for a value
  // of 4 chars or fewer, erring toward masking more of a short ID), e.g.
  // "123456789" -> "•••••6789", "AB12" -> "••12", "XY" -> "•Y".
  static String _maskIdNumber(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '—';
    final int keep;
    if (v.length > 4) {
      keep = 4;
    } else if (v.length > 2) {
      keep = 2;
    } else {
      keep = 1;
    }
    final visible = v.substring(v.length - keep);
    final maskedCount = v.length - keep;
    return ('•' * maskedCount) + visible;
  }

  static String _optionLabel(
    List<StrowalletCardHolderOption> options,
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) return '—';
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return value;
  }

  String _countryLabel() {
    final iso3 = controller.selectedCountryIso3.value;
    final raw = iso3.isNotEmpty ? iso3 : controller.countryController.text;
    if (raw.trim().isEmpty) return '—';
    for (final c in controller.countries) {
      if ('${c.iso3}'.toUpperCase() == raw.toUpperCase()) return '${c.name}';
    }
    return _dv(raw);
  }

  // Relative upload paths need the admin-configured asset host prepended;
  // an already-absolute URL (the shape some backend fields use) is passed
  // through untouched. Verify against a real get/card-holder response which
  // shape `id_image` actually comes back as.
  String _resolveAssetUrl(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http://') || v.startsWith('https://')) return v;
    final base = Get.find<AppSettingsController>().assetBaseUrl.value;
    if (base.isEmpty) return v;
    return v.startsWith('/') ? '$base$v' : '$base/$v';
  }

  Widget _readOnlyBodyWidget(BuildContext context) {
    return Obx(() {
      final imageUrl = controller.existingIdImageUrl.value;
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        physics: const BouncingScrollPhysics(),
        children: [
          SCSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    _customerDetailsTitle,
                    style: AppTextStyles.h2.copyWith(color: AppColors.text),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: AppColors.line2),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    children: [
                      _DetailRow(label: _t('name'), value: _dv(controller.nameController.text)),
                      _DetailRow(label: _t(Strings.firstName), value: _dv(controller.firstNameController.text)),
                      _DetailRow(label: _t(Strings.lastName), value: _dv(controller.lastNameController.text)),
                      _DetailRow(label: _t(Strings.dateOfBirth), value: _dv(controller.dobController.text)),
                      _DetailRow(label: _t('idType'), value: _idTypeLabel(controller.idType.value)),
                      _DetailRow(
                        label: _t(Strings.idNumber),
                        value: _maskIdNumber(controller.idNumberController.text),
                        mono: true,
                      ),
                      _DetailRow(label: _t('email'), value: _dv(controller.emailController.text)),
                      _DetailRow(label: _t(Strings.address), value: _dv(controller.line1Controller.text)),
                      _DetailRow(label: _t(Strings.city), value: _dv(controller.cityController.text)),
                      _DetailRow(label: _t(Strings.state), value: _dv(controller.stateController.text)),
                      _DetailRow(label: _t(Strings.zipCode), value: _dv(controller.postalCodeController.text), mono: true),
                      _DetailRow(label: _t(Strings.country), value: _countryLabel()),
                      _DetailRow(
                        label: _t(Strings.accountPurpose),
                        value: _optionLabel(StrowalletCardHolderOptions.accountPurpose, controller.accountPurpose.value),
                      ),
                      _DetailRow(
                        label: _t(Strings.employmentStatus),
                        value: _optionLabel(StrowalletCardHolderOptions.employmentStatus, controller.employmentStatus.value),
                      ),
                      _DetailRow(
                        label: _t(Strings.occupation),
                        value: _optionLabel(StrowalletCardHolderOptions.occupation, controller.occupation.value),
                      ),
                      _DetailRow(
                        label: _t('phoneCode'),
                        value: _dv(controller.phoneCodeController.text),
                      ),
                      _DetailRow(label: _t(Strings.phone), value: _dv(controller.phoneController.text)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (imageUrl.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              _t(Strings.idImage),
              style: AppTextStyles.label.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: 6),
            _idImagePreview(context, imageUrl),
          ],
        ],
      );
    });
  }

  // Bounded, finite-sized box for the ID image preview — SCNetworkImage's
  // cache-size math (width * devicePixelRatio).round() throws on an infinite
  // width, so this resolves the actual available width via LayoutBuilder
  // instead of passing double.infinity. BoxFit.contain can letterbox (the ID
  // document's aspect ratio rarely matches the box), so a theme-aware muted
  // background sits behind it to make that empty space look intentional.
  Widget _idImagePreview(BuildContext context, String imageUrl) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final boxColor = dark ? AppColorsDark.surface2 : AppColors.surface2;
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        final boxHeight = 180.h;
        return Container(
          width: boxWidth,
          height: boxHeight,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: SCNetworkImage(
            url: _resolveAssetUrl(imageUrl),
            width: boxWidth,
            height: boxHeight,
            radius: AppRadius.lg,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  Widget _idTypeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('idType'),
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.idType.value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: UpdateCustomerKycController.idTypeOptions
                    .map(
                      (v) => DropdownMenuItem<String>(
                        value: v,
                        child: Text(_idTypeLabel(v)),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) controller.idType.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _accountPurposeDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(Strings.accountPurpose),
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.accountPurpose.value,
                isExpanded: true,
                hint: Text(
                  _t(Strings.selectAccountPurpose),
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text3),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: StrowalletCardHolderOptions.accountPurpose
                    .map(
                      (o) => DropdownMenuItem<String>(
                        value: o.value,
                        child: Text(o.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.accountPurpose.value = v,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _employmentStatusDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(Strings.employmentStatus),
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.employmentStatus.value,
                isExpanded: true,
                hint: Text(
                  _t(Strings.selectEmploymentStatus),
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text3),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: StrowalletCardHolderOptions.employmentStatus
                    .map(
                      (o) => DropdownMenuItem<String>(
                        value: o.value,
                        child: Text(o.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.employmentStatus.value = v,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _occupationDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(Strings.occupation),
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line2, width: 1),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.occupation.value,
                isExpanded: true,
                hint: Text(
                  _t(Strings.selectOccupation),
                  style: AppTextStyles.bodyMed.copyWith(color: AppColors.text3),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                items: StrowalletCardHolderOptions.occupation
                    .map(
                      (o) => DropdownMenuItem<String>(
                        value: o.value,
                        child: Text(o.label),
                      ),
                    )
                    .toList(),
                onChanged: (v) => controller.occupation.value = v,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // id_image is optional (server only requires it when the user has no
  // existing KYC image on file) — no asterisk, matching the rest of this form.
  Widget _idImageField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(Strings.idImage),
          style: AppTextStyles.label.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final file = controller.idImageFile.value;
          return InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => _pickIdImageSource(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.line2, width: 1),
              ),
              child: file == null
                  ? Row(
                      children: [
                        const Icon(Icons.file_upload_outlined,
                            size: 20, color: AppColors.text3),
                        const SizedBox(width: 10),
                        Expanded(
                          // Static literal, not a Strings/.tr key: the backend
                          // language dictionary doesn't carry this text, which
                          // would otherwise print the raw key instead of copy.
                          child: Text(
                            'Tap to select image',
                            style: AppTextStyles.bodyMed
                                .copyWith(color: AppColors.text3),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Image.file(
                            file,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            file.path.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMed
                                .copyWith(color: AppColors.text),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _t(Strings.changeImage),
                          style:
                              AppTextStyles.label.copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
            ),
          );
        }),
      ],
    );
  }

  void _pickIdImageSource(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _t(Strings.idImage),
                style: AppTextStyles.h2.copyWith(color: AppColors.text),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _idImageSourceOption(
                      icon: Icons.image_outlined,
                      label: _t(Strings.fromGallery),
                      onTap: () {
                        Get.back();
                        controller.pickIdImage(ImageSource.gallery);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _idImageSourceOption(
                      icon: Icons.photo_camera_outlined,
                      label: _t(Strings.fromCamera),
                      onTap: () {
                        Get.back();
                        controller.pickIdImage(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _idImageSourceOption({
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

  // Country selector — a tappable field opening a searchable picker so the
  // user can only choose a valid country (stores its ISO-3 code). Replaces the
  // old free-text field that let invalid values reach the buy-card API.
  Widget _countryDropdown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_t(Strings.country),
            style: AppTextStyles.label.copyWith(color: AppColors.text2)),
        const SizedBox(height: 6),
        Obx(() {
          final iso3 = controller.selectedCountryIso3.value;
          String label = _t(Strings.selectCountry);
          for (final c in controller.countries) {
            if ('${c.iso3}' == iso3 && iso3.isNotEmpty) {
              label = '${c.name}';
              break;
            }
          }
          return InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: () => _pickCountry(context),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.line2, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMed.copyWith(
                        color: iso3.isEmpty ? AppColors.text3 : AppColors.text,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.text3),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _pickCountry(BuildContext context) {
    final all = controller.countries.toList();
    var filtered = all;
    Get.bottomSheet(
      StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),
              SCTextField(
                hint: _t(Strings.searchCountry),
                prefixIcon:
                    const Icon(Icons.search, size: 18, color: AppColors.text3),
                onChanged: (q) {
                  final query = q.trim().toLowerCase();
                  setSheet(() {
                    filtered = query.isEmpty
                        ? all
                        : all
                            .where((c) =>
                                '${c.name}'.toLowerCase().contains(query) ||
                                '${c.iso3}'.toLowerCase().contains(query))
                            .toList();
                  });
                },
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final c = filtered[i];
                    return ListTile(
                      dense: true,
                      title: Text('${c.name}',
                          style: AppTextStyles.bodyMed
                              .copyWith(color: AppColors.text)),
                      trailing: Text('${c.iso3}',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.text3)),
                      onTap: () {
                        controller.selectedCountryIso3.value = '${c.iso3}';
                        controller.countryController.text = '${c.iso3}';
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();
    DateTime initial = DateTime(now.year - 18, now.month, now.day);
    final parsed = DateTime.tryParse(controller.dobController.text.trim());
    if (parsed != null) initial = parsed;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      controller.dobController.text = '${picked.year}-$m-$d';
    }
  }
}

// Read-only label/value row — mirrors the `_DetailRow` convention already
// used by strowallet_details_screen.dart and the other card-details screens.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: mono
                  ? AppTextStyles.numSm.copyWith(color: AppColors.text)
                  : AppTextStyles.bodyMed.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
