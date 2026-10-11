import 'package:flutter/services.dart';

import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/views/auth/controller/login/otp_reset_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";

class ResetOtpScreen extends StatefulWidget {
  const ResetOtpScreen({super.key});

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  static const int _length = 6;

  late final ResetOtpController controller;
  final otpFormKey = GlobalKey<FormState>();

  late final List<TextEditingController> _cellControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetOtpController());
    _cellControllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());

    // If the controller already has a partial OTP (e.g. coming back to
    // the screen), seed the cells from it.
    final existing = controller.otpController.text;
    for (int i = 0; i < _length && i < existing.length; i++) {
      _cellControllers[i].text = existing[i];
    }

    // Rebuild on focus changes so the focused cell border updates.
    for (final node in _focusNodes) {
      node.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    for (final c in _cellControllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.removeListener(_onFocusChanged);
      n.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  String get _combined => _cellControllers.map((c) => c.text).join();
  bool get _allFilled => _cellControllers.every((c) => c.text.isNotEmpty);

  void _syncToController() {
    final value = _combined;
    controller.otpController.text = value;
    controller.changeCurrentText(value);
  }

  void _onCellChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _syncToController();
    setState(() {});
    if (_allFilled) {
      _verify();
    }
  }

  void _onBackspaceOnEmpty(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verify() {
    if (!_allFilled) return;
    controller.forgetPasswordVerifyEmailProcess();
  }

  void _resend() {
    for (final c in _cellControllers) {
      c.clear();
    }
    _syncToController();
    _focusNodes.first.requestFocus();
    setState(() {});
    controller.resendCode();
    controller.resendResetCodeProcess();
  }

  String _maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final local = parts[0];
    final domain = parts.sublist(1).join('@');
    final visible = local.length >= 2 ? local.substring(0, 2) : local;
    return '$visible•••@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final destination = controller.controller.forgetEmailAddressController.text;
    final masked = destination.isEmpty
        ? Get.find<LanguageController>().getTranslation(Strings.yourEmail)
        : _maskEmail(destination);

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
                    Strings.verifyYourEmail,
                  ),
                  style: AppTextStyles.h1.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  '${Get.find<LanguageController>().getTranslation(Strings.weSentCodeTo)} $masked.',
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 40),
                Center(child: _buildOtpRow()),
                const SizedBox(height: 24),
                Center(child: _buildResend()),
                const Spacer(),
                Obx(
                  () => SCPrimaryButton(
                    label: Get.find<LanguageController>().getTranslation(
                      Strings.verify,
                    ),
                    loading: controller.isLoading,
                    onPressed: _allFilled ? _verify : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_length, (i) {
        return _OtpCell(
          controller: _cellControllers[i],
          focusNode: _focusNodes[i],
          onChanged: (v) => _onCellChanged(i, v),
          onBackspaceOnEmpty: () => _onBackspaceOnEmpty(i),
        );
      }),
    );
  }

  Widget _buildResend() {
    return Obx(() {
      final total =
          controller.secondsRemaining.value +
          controller.minuteRemaining.value * 60;
      if (total > 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Get.find<LanguageController>().getTranslation(
                Strings.resendCodeIn,
              ),
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            Text(
              '${total}s',
              style: AppTextStyles.numMd.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }
      return SCGhostButton(
        label: Get.find<LanguageController>().getTranslation(
          Strings.resendCode,
        ),
        onPressed: _resend,
        fullWidth: false,
      );
    });
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspaceOnEmpty,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspaceOnEmpty;

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    final isFilled = controller.text.isNotEmpty;

    return SizedBox(
      width: 48,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isFilled ? AppColors.surface : AppColors.surface2,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isFocused ? AppColors.accent : AppColors.line,
                width: isFocused ? 1.5 : 0.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              controller.text,
              style: AppTextStyles.h1.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
          Positioned.fill(
            child: Focus(
              canRequestFocus: false,
              onKeyEvent: (FocusNode node, KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    controller.text.isEmpty) {
                  onBackspaceOnEmpty();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                showCursor: false,
                cursorColor: Colors.transparent,
                style: const TextStyle(color: Colors.transparent),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
