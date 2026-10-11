// ignore_for_file: use_build_context_synchronously

import 'package:flutter/services.dart';
import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/views/two_fa/controller/two_fa_otp_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";

class Otp2FaScreen extends StatefulWidget {
  const Otp2FaScreen({super.key});

  @override
  State<Otp2FaScreen> createState() => _Otp2FaScreenState();
}

class _Otp2FaScreenState extends State<Otp2FaScreen> {
  static const int _length = 6;

  late final TwoFaOtpController controller;

  late final List<TextEditingController> _cellControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TwoFaOtpController());
    _cellControllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());

    final existing = controller.emailOtpInputController.text;
    for (int i = 0; i < _length && i < existing.length; i++) {
      _cellControllers[i].text = existing[i];
    }

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
    controller.emailOtpInputController.text = value;
    controller.currentText.value = value;
  }

  void _onCellChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _syncToController();
    setState(() {});
    if (_allFilled) {
      _submit();
    }
  }

  void _onBackspaceOnEmpty(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  // ── Submit — preserves the original 2FA verify + success flow ───────────
  void _submit() {
    if (!_allFilled) return;
    controller.twoFAEnabledProcess().then(
      (value) => StatusScreen.show(
        context: context,
        subTitle: Get.find<LanguageController>().getTranslation(Strings.yourTwoSecurityHAsBeenActive),
        onPressed: () {
          LocalStorage.isLoginSuccess(isLoggedIn: true);
          LocalStorage.isLoggedIn();
          Get.offAllNamed(Routes.bottomNavBarScreen);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (isTrue, value) {
        Get.close(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Get.close(0),
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
                  Get.find<LanguageController>()
                      .getTranslation(Strings.enableFasecurity),
                  style: AppTextStyles.h1.copyWith(color: AppColors.text),
                ),
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.enterTheGoogleAuthOTPCode),
                  style: AppTextStyles.body.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: 40),
                Center(child: _buildOtpRow()),
                const Spacer(),
                Obx(
                  () => SCPrimaryButton(
                    label: Get.find<LanguageController>()
                        .getTranslation(Strings.submit),
                    loading: controller.isLoading,
                    onPressed: _allFilled ? _submit : null,
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
