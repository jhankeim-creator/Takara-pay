import 'package:flutter/services.dart';

import "package:TAKARA PAY/views/withdraw/controller/withdraw_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_spacing.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";

class MoneyOutManualPaymentScreen extends StatefulWidget {
  const MoneyOutManualPaymentScreen({super.key});

  @override
  State<MoneyOutManualPaymentScreen> createState() =>
      _MoneyOutManualPaymentScreenState();
}

class _MoneyOutManualPaymentScreenState
    extends State<MoneyOutManualPaymentScreen> {
  late final MoneyOutController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(MoneyOutController());
    for (final c in controller.inputFieldControllers) {
      c.addListener(_onAnyFieldChanged);
    }
  }

  @override
  void dispose() {
    for (final c in controller.inputFieldControllers) {
      c.removeListener(_onAnyFieldChanged);
    }
    super.dispose();
  }

  void _onAnyFieldChanged() {
    if (mounted) setState(() {});
  }

  bool get _allFilled {
    final ctls = controller.inputFieldControllers;
    if (ctls.isEmpty) return false;
    for (final c in ctls) {
      if (c.text.trim().isEmpty) return false;
    }
    return true;
  }

  // Submit — preserved from the original button.
  void _onSubmit() {
    if (formKey.currentState!.validate()) {
      Get.toNamed(Routes.moneyOutPreviewScreen);
    }
  }

  IconData _iconForLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('bank')) return Icons.account_balance_outlined;
    if (l.contains('holder') || l.contains('name')) {
      return Icons.person_outline;
    }
    if (l.contains('rout') || l.contains('aba') || l.contains('iban')) {
      return Icons.numbers_outlined;
    }
    if (l.contains('account')) return Icons.credit_card_outlined;
    return Icons.short_text;
  }

  bool _isAccountField(String label, String name) {
    final s = '${label.toLowerCase()} ${name.toLowerCase()}';
    return s.contains('account') && s.contains('number');
  }

  @override
  Widget build(BuildContext context) {
    final amount = controller.moneyOutAmountTextController.text;

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
          Get.find<LanguageController>().getTranslation(Strings.bankDetails),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.manualTransfer),
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                _buildAmountSummary(amount),
                const SizedBox(height: 28),
                _buildDynamicFields(),
                const SizedBox(height: 20),
                _buildTrustCard(),
                const SizedBox(height: 32),
                SCPrimaryButton(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.continueLabel),
                  onPressed: _allFilled ? _onSubmit : null,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSummary(String amount) {
    final shown = amount.isEmpty ? '0' : amount;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.north_rounded,
              color: AppColors.accentInk,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.withdrawing),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.text2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$$shown',
                  style: AppTextStyles.numMd.copyWith(color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicFields() {
    // moneyOutInsertModel is nullable on the controller — when the
    // /withdraw/insert API errored out, the field stays null and reading
    // `.data.inputFields` would throw LateInitializationError.
    final model = controller.moneyOutInsertModel;
    if (model == null) {
      return const SizedBox.shrink();
    }
    final fieldsMeta = model.data.inputFields;
    final ctls = controller.inputFieldControllers;

    if (ctls.isEmpty || fieldsMeta.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          Get.find<LanguageController>()
              .getTranslation(Strings.noFieldsAvailableForThisGateway),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
          ),
        ),
      );
    }

    final children = <Widget>[];
    for (int i = 0; i < ctls.length && i < fieldsMeta.length; i++) {
      final meta = fieldsMeta[i];
      final type = meta.type.toString();
      // Skip file-type fields — original rendered a separate file picker
      // widget for them which we are not porting here.
      if (type.contains('file')) continue;

      final label = meta.label.toString();
      final name = meta.name.toString();
      final maxLen =
          int.tryParse(meta.validation.max.toString()) ?? 0;
      final required = meta.required == true;
      final isAccount = _isAccountField(label, name);

      if (children.isNotEmpty) children.add(const SizedBox(height: 16));
      children.add(
        SCTextField(
          label: label,
          hint: label,
          obscure: isAccount,
          maxLength: maxLen > 0 ? maxLen : null,
          inputFormatters: maxLen > 0
              ? [LengthLimitingTextInputFormatter(maxLen)]
              : null,
          controller: ctls[i],
          prefixIcon: Icon(
            _iconForLabel(label),
            size: 18,
            color: AppColors.text3,
          ),
        ),
      );
      if (required) {
        // No native validator on SCTextField; the formKey.validate() check
        // is preserved via _onSubmit, but actual per-field validators are
        // not currently wired to SCTextField. Adjust if validation messages
        // are needed.
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildTrustCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              Get.find<LanguageController>().getTranslation(
                  Strings.weVerifyOwnershipWithMicroDeposits),
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF064E3B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
