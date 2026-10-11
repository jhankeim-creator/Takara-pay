import 'package:flutter/services.dart';

import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/money_transfer/controller/money_transfer_controller.dart";
import "package:TAKARA PAY/views/money_transfer/controller/money_transfer_info_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/navbar_controller.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_text_field.dart";

class MonetTransferScreen extends StatefulWidget {
  const MonetTransferScreen({super.key});

  @override
  State<MonetTransferScreen> createState() => _MonetTransferScreenState();
}

class _MonetTransferScreenState extends State<MonetTransferScreen> {
  late final MoneyTransferController controller;
  late final MoneyTransferInfoController infoController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MoneyTransferController());
    infoController = Get.put(MoneyTransferInfoController());
    controller.receiverEmailController.addListener(_onReceiverChanged);
    controller.amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    controller.receiverEmailController.removeListener(_onReceiverChanged);
    controller.amountController.removeListener(_onAmountChanged);
    super.dispose();
  }

  // Any edit to the email invalidates a prior verification.
  void _onReceiverChanged() {
    controller.clearVerification();
    if (mounted) setState(() {});
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  double get _amount =>
      double.tryParse(controller.amountController.text.trim()) ?? 0;

  String _fmt(double v) => v.toStringAsFixed(2);

  void _onContinue() {
    if (!controller.isVerified) {
      CustomSnackBar.error(Get.find<LanguageController>()
          .getTranslation(Strings.pleaseVerifyRecipientFirst));
      return;
    }
    final amt = _amount;
    final min = controller.minLimit;
    final max = controller.maxLimit;
    if (amt <= 0) {
      CustomSnackBar.error(Get.find<LanguageController>()
          .getTranslation(Strings.enterAmountToSend));
      return;
    }
    if ((min > 0 && amt < min) || (max > 0 && amt > max)) {
      CustomSnackBar.error('Amount must be between \$${_fmt(min)} and \$${_fmt(max)}.');
      return;
    }
    final fee = controller.fixedCharge + amt * controller.percentCharge / 100;
    if (amt + fee > infoController.balance.value) {
      CustomSnackBar.error(Get.find<LanguageController>()
          .getTranslation(Strings.insufficientBalanceForTransfer));
      return;
    }
    Get.toNamed(Routes.moneyTransferPreviewScreen);
  }

  // Send can be reached two ways: pushed as its own route, or shown inside the
  // navbar shell as page[2]. Pop if possible; otherwise fall back to Wallet.
  void _back() {
    if (Navigator.of(context).canPop()) {
      Get.back();
      return;
    }
    final navbar = Get.isRegistered<NavbarController>()
        ? Get.find<NavbarController>()
        : Get.put(NavbarController());
    navbar.selectedIndex.value = 1;
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
          onPressed: _back,
        ),
        title: Text(
          Get.find<LanguageController>().getTranslation(Strings.sendMoney),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Get.find<LanguageController>()
                          .getTranslation(Strings.whoIsItFor),
                      style: AppTextStyles.h1.copyWith(color: AppColors.text),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Get.find<LanguageController>().getTranslation(
                          Strings.sendInstantlyToStripCardUser),
                      style:
                          AppTextStyles.body.copyWith(color: AppColors.text2),
                    ),
                    const SizedBox(height: 20),

                    // ── Recipient email + instant verify ──────────────────
                    Text(
                        Get.find<LanguageController>()
                            .getTranslation(Strings.recipientEmailLabel),
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.text2)),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SCTextField(
                            hint: 'name@email.com',
                            controller: controller.receiverEmailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.mail_outline,
                                size: 18, color: AppColors.text3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildVerifyButton(),
                      ],
                    ),
                    Obx(() => _buildVerifyResult()),

                    const SizedBox(height: 20),

                    // ── Amount ───────────────────────────────────────────
                    Text(
                        Get.find<LanguageController>()
                            .getTranslation(Strings.amount),
                        style: AppTextStyles.label
                            .copyWith(color: AppColors.text2)),
                    const SizedBox(height: 6),
                    SCTextField(
                      hint: '0.00',
                      controller: controller.amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(r'$',
                            style: AppTextStyles.bodyMed
                                .copyWith(color: AppColors.text2)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Limit information ─────────────────────────────────
                    Obx(() => _buildLimitInfo()),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Obx(() {
      final canVerify =
          controller.receiverEmailController.text.trim().isNotEmpty &&
              !controller.isVerifying;
      return SizedBox(
        height: 52,
        child: SCSecondaryButton(
          label: controller.isVerifying
              ? '...'
              : (controller.isVerified
                  ? Get.find<LanguageController>()
                      .getTranslation(Strings.verified)
                  : Get.find<LanguageController>()
                      .getTranslation(Strings.verify)),
          fullWidth: false,
          onPressed: canVerify ? controller.verifyRecipient : null,
        ),
      );
    });
  }

  Widget _buildVerifyResult() {
    if (controller.isVerified) {
      final u = controller.verifiedUser.value!;
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentSoft,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.accent.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.fullName,
                        style: AppTextStyles.bodyMed
                            .copyWith(color: AppColors.text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(u.email,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.text2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (controller.verifyError.value.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.danger, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(controller.verifyError.value,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.danger)),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLimitInfo() {
    final min = controller.minLimit;
    final max = controller.maxLimit;
    final fixed = controller.fixedCharge;
    final percent = controller.percentCharge;
    final feeText = (fixed == 0 && percent == 0)
        ? Get.find<LanguageController>().getTranslation(Strings.noCharge)
        : '\$${_fmt(fixed)} + ${percent.toStringAsFixed(percent % 1 == 0 ? 0 : 2)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        children: [
          _infoRow(
              Get.find<LanguageController>()
                  .getTranslation(Strings.availableBalance),
              '\$${_fmt(infoController.balance.value)} ${infoController.currency.value}'),
          const SizedBox(height: 10),
          _infoRow(
              Get.find<LanguageController>()
                  .getTranslation(Strings.transferLimitLabel),
              '\$${_fmt(min)} - \$${_fmt(max)}'),
          const SizedBox(height: 10),
          _infoRow(
              Get.find<LanguageController>().getTranslation(Strings.charge),
              feeText),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2)),
        ),
        const SizedBox(width: 12),
        Text(value,
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text)),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Obx(
        () => SCPrimaryButton(
          label: controller.isVerified
              ? Get.find<LanguageController>()
                  .getTranslation(Strings.continueLabel)
              : Get.find<LanguageController>()
                  .getTranslation(Strings.verifyRecipientToContinue),
          onPressed:
              (controller.isVerified && _amount > 0) ? _onContinue : null,
        ),
      ),
    );
  }
}
