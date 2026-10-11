import 'package:google_fonts/google_fonts.dart';

import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/base/widgets/others/glass_widget.dart";

import "package:TAKARA PAY/views/auth/controller/login/signin_controller.dart";
import "package:TAKARA PAY/views/fingerprint/controller/fingerprint_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_brand_logo.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";
import "package:TAKARA PAY/base/widgets/inputs/forgot_password_input.dart";

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final controller = Get.put(SignInController());
  final fingerprintController = Get.put(FingerprintController());
  final phoneNumberFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: signInFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBrandRow(),
                const SizedBox(height: 48),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.welcomeBack,
                  ),
                  style: AppTextStyles.h1.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>().getTranslation(
                    Strings.signInToContinue,
                  ),
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 40),
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
                        hint: '••••••••',
                        controller: controller.passwordController,
                        obscure: true,
                        autofillHints: const [AutofillHints.password],
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SCGhostButton(
                    label: Get.find<LanguageController>().getTranslation(
                      Strings.forgotPassword,
                    ),
                    onPressed: () => _openDialogue(context),
                    fullWidth: false,
                  ),
                ),
                const SizedBox(height: 32),
                Obx(
                  () => SCPrimaryButton(
                    label: Get.find<LanguageController>().getTranslation(
                      Strings.signIn,
                    ),
                    loading: controller.isLoading,
                    onPressed: () {
                      if (signInFormKey.currentState!.validate()) {
                        controller.loginProcess();
                      }
                    },
                  ),
                ),
                Builder(
                  builder: (context) {
                    final platform = Theme.of(context).platform;
                    final isMobile =
                        platform == TargetPlatform.iOS ||
                        platform == TargetPlatform.android;
                    // Only offer biometric once the user has signed in with a
                    // password at least once (so a session is remembered).
                    final showBiometric =
                        isMobile && LocalStorage.isBiometricEnabled();
                    if (!showBiometric) return const SizedBox.shrink();
                    final isIOS = platform == TargetPlatform.iOS;
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SCSecondaryButton(
                        label: isIOS
                            ? Get.find<LanguageController>().getTranslation(
                                Strings.signInWithFaceId,
                              )
                            : Get.find<LanguageController>().getTranslation(
                                Strings.signInWithFingerprint,
                              ),
                        icon: isIOS ? Icons.face_outlined : Icons.fingerprint,
                        onPressed: () => _handleBiometricSignIn(context),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Get.find<LanguageController>().getTranslation(
                        Strings.newHere,
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.onPressedSignUP(),
                      child: Text(
                        Get.find<LanguageController>().getTranslation(
                          Strings.createAccount,
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
    return const Row(children: [ScBrandLogo(height: 30)]);
  }

  // Biometric sign-in handler.
  //
  // Flow: the user signs in with their password once — that remembers the
  // credentials (LocalStorage.enableBiometric, from the login controller).
  // Tapping the button runs the OS biometric prompt (local_auth); on success we
  // perform a REAL login with the remembered credentials so we always obtain a
  // fresh, valid token. (Restoring the old token failed because the server
  // invalidates it on logout → 401 → bounce back to the login screen.)
  Future<void> _handleBiometricSignIn(BuildContext context) async {
    if (!LocalStorage.isBiometricEnabled()) {
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.signInOnceForFingerprint,
        ),
      );
      return;
    }

    final result = await Authentication.authenticate(
      reason: Get.find<LanguageController>().getTranslation(
        Strings.verifyIdentityToSignIn,
      ),
    );
    if (!result.success) {
      // Give the user a reason instead of a silent no-op.
      if (result.error != null && result.error!.isNotEmpty) {
        CustomSnackBar.error(result.error!);
      }
      return;
    }

    final email = LocalStorage.getBiometricEmail();
    final password = LocalStorage.getBiometricPassword();
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.signInOnceForFingerprint,
        ),
      );
      return;
    }

    // Real login with the remembered credentials → fresh token. loginProcess
    // also handles email-verify / 2FA / dashboard routing like a normal sign-in.
    controller.emailAddressController.text = email;
    controller.passwordController.text = password;
    await controller.loginProcess();
  }

  // Forgot-password dialog — preserved verbatim from the previous build.
  // The dialog still uses the legacy primary widgets so that the existing
  // forget-password flow (forgetEmailAddressController, forgetPasswordEmailProcess,
  // isForgetPasswordLoading) keeps working unchanged.
  _openDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                Container(
                  width: width * 0.84,
                  margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                  padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                  decoration: BoxDecoration(
                    color: CustomColor.whiteColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.radius * 1.4,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossStart,
                    children: [
                      SizedBox(height: Dimensions.heightSize * 2),
                      const TitleHeading2Widget(
                        text: Strings.forgotPassword,
                        color: CustomColor.thirdLightTextColor,
                      ),
                      verticalSpace(Dimensions.heightSize * 0.5),
                      TitleHeading4Widget(
                        text: Strings.pleaseEnterYourRegister,
                        color: CustomColor.thirdLightTextColor.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      SizedBox(height: Dimensions.heightSize * 1),
                      Form(
                        key: forgotPasswordFormKey,
                        child: ForgotInputWidget(
                          keyboardInputType: TextInputType.emailAddress,
                          controller: controller.forgetEmailAddressController,
                          hint: Strings.enterEmailAddress,
                          label: Strings.emailAddress,
                        ),
                      ),
                      verticalSpace(Dimensions.heightSize),
                      Obx(
                        () => controller.isForgetPasswordLoading
                            ? CustomLoadingAPI(
                                color: CustomColor.primaryLightColor,
                              )
                            : PrimaryButton(
                                buttonColor: CustomColor.primaryBGLightColor,
                                height: Dimensions.buttonHeight * 0.8,
                                title: Get.find<LanguageController>()
                                    .getTranslation(Strings.forgetPassword),
                                onPressed: () {
                                  if (forgotPasswordFormKey.currentState!
                                      .validate()) {
                                    controller.forgetPasswordEmailProcess();
                                  }
                                },
                                borderColor: CustomColor.primaryBGLightColor,
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: const CircleAvatar(
                      backgroundColor: CustomColor.primaryBGLightColor,
                      child: Icon(Icons.close, color: CustomColor.whiteColor),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ).customGlassWidget(blurY: 1, blurX: 1),
    );
  }
}
