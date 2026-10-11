import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";
import "package:stripcard/views/drawer/controller/change_password_controller.dart";

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final controller = Get.put(PasswordController());

  String _t(String key) => Get.find<LanguageController>().getTranslation(key);

  void _onSubmit() {
    // Preserves the original "field must not be empty" validation that the
    // previous TextFormField-based inputs enforced.
    if (controller.oldPasswordController.text.isEmpty ||
        controller.newPasswordController.text.isEmpty ||
        controller.confirmPasswordController.text.isEmpty) {
      CustomSnackBar.error(_t(Strings.pleaseFillOutTheField));
      return;
    }
    controller.updatePasswordProcess();
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
        title: Text(
          _t(Strings.changePassword),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      physics: const BouncingScrollPhysics(),
      children: [
        SCTextField(
          controller: controller.oldPasswordController,
          label: _t(Strings.oldPassword),
          hint: _t(Strings.enterOldPassword),
          obscure: true,
        ),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.newPasswordController,
          label: _t(Strings.newPassword),
          hint: _t(Strings.enterNewPassword),
          obscure: true,
        ),
        const SizedBox(height: 16),
        SCTextField(
          controller: controller.confirmPasswordController,
          label: _t(Strings.confirmPassword),
          hint: _t(Strings.enterConfirmPassword),
          obscure: true,
        ),
        const SizedBox(height: 32),
        Obx(
          () => SCPrimaryButton(
            label: _t(Strings.changePassword),
            loading: controller.isLoading,
            onPressed: _onSubmit,
          ),
        ),
      ],
    );
  }
}
