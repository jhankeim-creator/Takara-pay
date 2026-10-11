import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/views/auth/controller/login/reset_password_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller = Get.put(ResetPasswordController());
  final resetFormKey = GlobalKey<FormState>();

  // Local reactive mirrors of the password text so the Save button's enabled
  // state and the inline mismatch error update on every keystroke.
  final _newPwdText = ''.obs;
  final _confirmPwdText = ''.obs;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didpop, dynamic _) {
        if (didpop) return;
        Get.offAllNamed(Routes.signInScreen);
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Get.toNamed(Routes.signInScreen),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.newPassword,
                  ),
                  style: AppTextStyles.h1.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.pickSomethingAtLeast8Characters,
                  ),
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 32),
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SCTextField(
                        label: Get.find<LanguageController>().getTranslation(
                          Strings.newPassword,
                        ),
                        controller: controller.newPasswordController,
                        obscure: true,
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: (v) => _newPwdText.value = v,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final pwd = _newPwdText.value;
                        final confirm = _confirmPwdText.value;
                        final mismatch = confirm.isNotEmpty && confirm != pwd;
                        return SCTextField(
                          label: Get.find<LanguageController>().getTranslation(
                            Strings.confirmPassword,
                          ),
                          controller: controller.confirmPasswordController,
                          obscure: true,
                          autofillHints: const [AutofillHints.newPassword],
                          onChanged: (v) => _confirmPwdText.value = v,
                          error: mismatch
                              ? Get.find<LanguageController>().getTranslation(
                                  Strings.passwordsDontMatch,
                                )
                              : null,
                        );
                      }),
                    ],
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final pwd = _newPwdText.value;
                  final confirm = _confirmPwdText.value;
                  final canSave = pwd.length >= 8 && pwd == confirm;
                  return SCPrimaryButton(
                    label: Get.find<LanguageController>().getTranslation(
                      Strings.saveAndSignIn,
                    ),
                    loading: controller.isLoading,
                    onPressed: canSave
                        ? () => controller.changePasswordProcess(context)
                        : null,
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
