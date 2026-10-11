import "package:stripcard/views/app_settings/controller/app_settings_controller.dart";
import "package:stripcard/base/utils/language/language_controller.dart";

import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/deposit/controller/deposit_controller.dart";
import "package:stripcard/views/deposit/controller/manual_gateway_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class DepositPreviewScreen extends StatelessWidget {
  DepositPreviewScreen({super.key});

  final depositController = Get.put(DepositController());
  final manualController = Get.put(ManualPaymentController());
  final dashboardController = Get.put(DashBoardController());
  final appSettingController = Get.put(AppSettingsController());

  String _t(String key) => Get.find<LanguageController>().getTranslation(key);

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
          _t(Strings.preview),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: _buildContent(context),
              ),
            ),
            _buildPinnedFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // ── Calculation preserved verbatim from the original
    // AddMoneyPreviewAmountInfo widget. Do not change. ──
    final double amount = depositController.amountController.text.isEmpty
        ? 0.0
        : double.parse(depositController.amountController.text);

    final conversionAmount = amount * depositController.supportedRate.value;
    final percentageCharge = depositController.supportedRate.value *
        (amount / 100) *
        depositController.percentCharge.value;
    final feesAndChargeResult =
        percentageCharge + depositController.selectedFee.value;
    final totalPayableAmount = conversionAmount + feesAndChargeResult;

    final precision =
        depositController.remainingController.dashboardController.precision.value;
    final fractionDigits = depositController.crypto.value == '1'
        ? appSettingController.cryptoPrecisionValue.value
        : appSettingController.fiatPrecisionValue.value;

    final enteredAmount =
        '${double.tryParse(depositController.amountController.text)?.toStringAsFixed(precision)} ${depositController.baseCurrency}';
    final exchangeRate =
        '1 ${depositController.baseCurrency.value} = ${depositController.supportedRate.value.toStringAsFixed(fractionDigits)} ${depositController.code.value}';
    final fees =
        '${feesAndChargeResult.toStringAsFixed(fractionDigits)} ${depositController.code.value}';
    final conversion =
        '${conversionAmount.toStringAsFixed(precision)} ${depositController.code.value}';
    final received =
        '${amount.toStringAsFixed(dashboardController.precision.value)} ${depositController.baseCurrency}';
    final totalPayable =
        '${totalPayableAmount.toStringAsFixed(fractionDigits)} ${depositController.code.value}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Text(
            _t(Strings.enterAmount).toUpperCase(),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            enteredAmount,
            style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        SCSectionHeader(label: _t(Strings.amountInformation)),
        SCSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _PreviewRow(label: _t(Strings.enterAmount), value: enteredAmount),
              const _RowDivider(),
              _PreviewRow(label: _t(Strings.exchangeRate), value: exchangeRate),
              const _RowDivider(),
              _PreviewRow(label: _t(Strings.feesAndCharges), value: fees),
              const _RowDivider(),
              _PreviewRow(label: _t(Strings.conversionAmount), value: conversion),
              const _RowDivider(),
              _PreviewRow(label: _t(Strings.recipientReceived), value: received),
              const _RowDivider(),
              _PreviewRow(
                label: _t(Strings.totalPayable),
                value: totalPayable,
                emphasised: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPinnedFooter(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line2, width: 1)),
      ),
      child: Obx(
        () => SCPrimaryButton(
          label: _t(Strings.confirm),
          loading: depositController.isPaypalLoading ||
              depositController.isStripeLoading ||
              manualController.isLoading,
          onPressed: () {
            depositController.paymentProceed();
          },
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: emphasised ? FontWeight.w600 : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.numMd.copyWith(
                color: AppColors.text,
                fontWeight: emphasised ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0.5,
      thickness: 0.5,
      color: AppColors.line,
    );
  }
}
