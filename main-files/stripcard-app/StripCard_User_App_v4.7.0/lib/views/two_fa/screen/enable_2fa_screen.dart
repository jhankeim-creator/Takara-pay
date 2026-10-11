import 'package:flutter/services.dart';

import "package:stripcard/views/two_fa/controller/enable_two_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_network_image.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";
import "package:stripcard/base/widgets/design_system/sc_text_field.dart";

enum _Method { app }

class Enable2FaScreen extends StatefulWidget {
  const Enable2FaScreen({super.key});

  @override
  State<Enable2FaScreen> createState() => _Enable2FaScreenState();
}

class _Enable2FaScreenState extends State<Enable2FaScreen> {
  late final TwoFaController controller;
  _Method? _selectedMethod = _Method.app;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TwoFaController());
    // Gate the Continue button on the code field so it only enables once a
    // full 6-digit authenticator code has been typed.
    controller.codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    controller.codeController.removeListener(_onCodeChanged);
    super.dispose();
  }

  void _onCodeChanged() {
    if (mounted) setState(() {});
  }

  bool get _codeReady => controller.codeController.text.trim().length == 6;

  void _onMethodTap(_Method method) {
    HapticFeedback.selectionClick();
    setState(() => _selectedMethod = method);
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
          Get.find<LanguageController>()
              .getTranslation(Strings.enableTwoFactorTitle),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }
          return _buildBody();
        }),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 28,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            Get.find<LanguageController>()
                .getTranslation(Strings.addExtraStepAtSignIn),
            style: AppTextStyles.h1.copyWith(
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Get.find<LanguageController>()
                .getTranslation(Strings.twoFaStopsAutomatedTakeover),
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
            ),
          ),
          const SizedBox(height: 28),
          SCSectionHeader(
            label: Get.find<LanguageController>().getTranslation(Strings.method),
          ),
          _MethodCard(
            method: _Method.app,
            icon: Icons.qr_code_2,
            title: Get.find<LanguageController>()
                .getTranslation(Strings.authenticatorApp),
            subtitle: Get.find<LanguageController>()
                .getTranslation(Strings.authenticatorAppExamples),
            recommended: true,
            selected: _selectedMethod == _Method.app,
            onTap: () => _onMethodTap(_Method.app),
          ),
          // Text-message and hardware-key methods removed — not supported by
          // the backend. Authenticator app is the only available 2FA method.
          const SizedBox(height: 24),
          if (_selectedMethod == _Method.app) _buildQrCard(),
          const SizedBox(height: 24),
          if (_selectedMethod == _Method.app) _buildCodeField(),
          const SizedBox(height: 32),
          Obx(
            () => SCPrimaryButton(
              label:
                  Get.find<LanguageController>().getTranslation(Strings.continueLabel),
              loading: controller.isSubmitLoading,
              onPressed: (_selectedMethod == null || !_codeReady)
                  ? null
                  : () => controller.twoFaSubmitApiProcess(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Verification code — required by the API to enable OR disable 2FA (proves
  // the user currently controls the authenticator, whether it was just set up
  // from the QR above or was already configured from a prior session).
  Widget _buildCodeField() {
    return SCTextField(
      label: Get.find<LanguageController>()
          .getTranslation(Strings.verificationCode),
      hint: Get.find<LanguageController>().getTranslation(Strings.sixDigitCode),
      controller: controller.codeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildQrCard() {
    // Fixed colors used inside this card so the QR remains readable on the
    // forced-white card background, even in dark mode.
    const onWhitePrimary = Color(0xFF0F172A);
    const onWhiteSecondary = Color(0xFF64748B);
    const pillBg = Color(0xFFF1F5F9);

    return SCSurfaceCard(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            color: Colors.white,
            child: Obx(() {
              final url = controller.qrCode.value;
              if (url.isEmpty) {
                return const Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 96,
                    color: onWhiteSecondary,
                  ),
                );
              }
              return SCNetworkImage(
                url: url,
                fit: BoxFit.contain,
                errorIcon: Icons.broken_image_outlined,
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            Get.find<LanguageController>()
                .getTranslation(Strings.scanQrCodeInstruction),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: onWhiteSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Manual setup key — for users who can't scan the QR. Shown with a
          // copy button so it can be pasted into the authenticator app.
          Obx(() {
            final secret = controller.secret.value;
            if (secret.isEmpty) return const SizedBox.shrink();
            return Column(
              children: [
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.cantScanEnterKeyManually),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: onWhiteSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _SecretKeyRow(
                  secret: secret,
                  pillBg: pillBg,
                  primary: onWhitePrimary,
                  secondary: onWhiteSecondary,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// Read-only setup key with a tap-to-copy affordance. Lives on the forced
/// white QR card, so it takes explicit on-white colors.
class _SecretKeyRow extends StatelessWidget {
  const _SecretKeyRow({
    required this.secret,
    required this.pillBg,
    required this.primary,
    required this.secondary,
  });

  final String secret;
  final Color pillBg;
  final Color primary;
  final Color secondary;

  void _copy() {
    Clipboard.setData(ClipboardData(text: secret));
    HapticFeedback.selectionClick();
    Get.snackbar(
      Get.find<LanguageController>().getTranslation(Strings.copied),
      Get.find<LanguageController>()
          .getTranslation(Strings.setupKeyCopiedToClipboard),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.text,
      colorText: AppColors.bg,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: pillBg,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: _copy,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  secret,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.copy_rounded, size: 18, color: secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.method,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.recommended,
    required this.selected,
    required this.onTap,
  });

  final _Method method;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool recommended;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: radius,
        border: Border.all(
          color: selected ? AppColors.accent : AppColors.line,
          width: selected ? 1.5 : 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: AppTextStyles.bodyMed.copyWith(
                                  color: AppColors.text,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (recommended) ...[
                              const SizedBox(width: 8),
                              const _RecommendedPill(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _RadioIndicator(selected: selected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendedPill extends StatelessWidget {
  const _RecommendedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        Get.find<LanguageController>().getTranslation(Strings.recommended),
        style: AppTextStyles.caption.copyWith(color: AppColors.accent),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.accent : Colors.transparent,
        shape: BoxShape.circle,
        border: selected
            ? null
            : Border.all(color: AppColors.text3, width: 1.5),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

