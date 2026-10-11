import 'package:flutter/gestures.dart';

import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/views/auth/controller/registration/signup_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final controller = Get.put(RegistrationController());
  final signUpFormKey = GlobalKey<FormState>();

  // Local reactive mirror of the password text so the strength meter rebuilds
  // on every keystroke without needing to listen to the underlying controller.
  final _passwordText = ''.obs;

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandRow(),
                const SizedBox(height: 32),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.createAccount,
                  ),
                  style: AppTextStyles.h1.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.takesAbout30Seconds,
                  ),
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SCTextField(
                        label: Get.find<LanguageController>().getTranslation(
                          Strings.firstName,
                        ),
                        hint: Get.find<LanguageController>().getTranslation(
                          Strings.firstNameExample,
                        ),
                        controller: controller.firstNameController,
                        autofillHints: const [AutofillHints.givenName],
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          size: 18,
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SCTextField(
                        label: Get.find<LanguageController>().getTranslation(
                          Strings.lastName,
                        ),
                        hint: Get.find<LanguageController>().getTranslation(
                          Strings.lastNameExample,
                        ),
                        controller: controller.lastNameController,
                        autofillHints: const [AutofillHints.familyName],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SCTextField(
                        label: Get.find<LanguageController>().getTranslation(
                          Strings.email,
                        ),
                        hint: Get.find<LanguageController>().getTranslation(
                          Strings.emailHintExample,
                        ),
                        controller: controller.emailAddressController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          size: 18,
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SCTextField(
                        label: Get.find<LanguageController>().getTranslation(
                          Strings.password,
                        ),
                        hint: Get.find<LanguageController>().getTranslation(
                          Strings.atLeast8Characters,
                        ),
                        controller: controller.passwordController,
                        obscure: true,
                        autofillHints: const [AutofillHints.newPassword],
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: AppColors.text3,
                        ),
                        onChanged: (v) => _passwordText.value = v,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => _buildStrengthMeter(context, _passwordText.value)),
                const SizedBox(height: 20),
                Obx(() => _buildTermsRow()),
                const SizedBox(height: 32),
                Obx(
                  () => SCPrimaryButton(
                    label: Get.find<LanguageController>().getTranslation(
                      Strings.createAccount,
                    ),
                    loading: controller.isLoading,
                    onPressed: controller.isSelected.value
                        ? () {
                            if (signUpFormKey.currentState!.validate()) {
                              controller.signUpProcess();
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Get.find<LanguageController>().getTranslation(
                        Strings.alreadyHaveOne,
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.onPressedSignIn(),
                      child: Text(
                        Get.find<LanguageController>().getTranslation(
                          Strings.signIn,
                        ),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandRow() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.text,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Text(
            'S',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'StripCard',
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ],
    );
  }

  ({int strength, String label, Color color}) _passwordMetrics(
    BuildContext context,
    String pwd,
  ) {
    if (pwd.isEmpty) {
      return (strength: 0, label: '', color: Colors.transparent);
    }

    int score = 0;
    if (pwd.length >= 8) score++;
    if (pwd.contains(RegExp(r'[A-Z]'))) score++;
    if (pwd.contains(RegExp(r'[0-9]'))) score++;
    if (pwd.contains(RegExp(r'[^A-Za-z0-9]'))) score++;

    final dark = Theme.of(context).brightness == Brightness.dark;

    switch (score) {
      case 0:
      case 1:
        return (
          strength: 1,
          label: Get.find<LanguageController>().getTranslation(Strings.tooWeak),
          color: dark ? AppColorsDark.danger : AppColors.danger,
        );
      case 2:
        return (
          strength: 2,
          label: Get.find<LanguageController>().getTranslation(Strings.weak),
          color: dark ? AppColorsDark.warn : AppColors.warn,
        );
      case 3:
        return (
          strength: 3,
          label: Get.find<LanguageController>().getTranslation(Strings.good),
          color: const Color(0xFF84CC16), // lime — between warn and accent
        );
      case 4:
        return (
          strength: 4,
          label: Get.find<LanguageController>().getTranslation(Strings.strong),
          color: dark ? AppColorsDark.accent : AppColors.accent,
        );
      default:
        return (strength: 0, label: '', color: Colors.transparent);
    }
  }

  Widget _buildStrengthMeter(BuildContext context, String password) {
    // Hide the entire meter while the field is empty so the gray bars
    // don't add noise before the user starts typing.
    if (password.isEmpty) return const SizedBox.shrink();

    final m = _passwordMetrics(context, password);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = dark ? AppColorsDark.line : AppColors.line;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final filled = i < m.strength;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: filled ? m.color : emptyColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
        if (m.label.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(m.label, style: AppTextStyles.caption.copyWith(color: m.color)),
        ],
      ],
    );
  }

  Widget _buildTermsRow() {
    final checked = controller.isSelected.value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.isSelected.value = !checked,
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: checked ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: checked
                  ? null
                  : Border.all(color: AppColors.text3, width: 1.5),
            ),
            child: checked
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              children: [
                TextSpan(
                  text: Get.find<LanguageController>().getTranslation(
                    Strings.iAgreeToStripcards,
                  ),
                ),
                TextSpan(
                  text: Get.find<LanguageController>().getTranslation(
                    Strings.terms,
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                  // No terms-link handler exists in the controller and no URL
                  // is configured. Wired to a no-op so the gesture is present
                  // and ready when a destination is added.
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                  text:
                      ' ${Get.find<LanguageController>().getTranslation(Strings.and)} ',
                ),
                TextSpan(
                  text: Get.find<LanguageController>().getTranslation(
                    Strings.privacyPolicy,
                  ),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
