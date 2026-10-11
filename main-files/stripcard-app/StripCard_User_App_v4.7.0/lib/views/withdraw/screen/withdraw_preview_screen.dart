import 'package:intl/intl.dart';

import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/withdraw/controller/withdraw_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_radius.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class MoneyOutPreviewScreen extends StatelessWidget {
  MoneyOutPreviewScreen({super.key});

  // Preserved field initializers from the original — these Get.put calls
  // re-resolve the same controller instances created upstream.
  final controller = Get.put(MoneyOutController());
  final dashController = Get.put(DashBoardController());

  String _fmt(double v) => NumberFormat('#,##0.00').format(v);

  @override
  Widget build(BuildContext context) {
    final raw = controller.moneyOutAmountTextController.text;
    final amount = raw.isEmpty ? 0.0 : (double.tryParse(raw) ?? 0.0);

    // Preserve the original fee calculation:
    //   percentageCharge = (1 / 100) * amount  (1% hardcoded)
    //   feesAndChargeResult = percentageCharge + controller.fixesCharge.value
    final serviceFee = (1 / 100) * amount;
    final networkFee = controller.fixesCharge.value;
    final youReceive = amount - networkFee - serviceFee;

    final bankName = controller.selectedCurrencyName.value;

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
              .getTranslation(Strings.confirmWithdrawal),
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  Get.find<LanguageController>()
                      .getTranslation(Strings.withdrawing)
                      .toUpperCase(),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildHeroAmount(amount),
              const SizedBox(height: 12),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.text2,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Get.find<LanguageController>().getTranslation(
                          Strings.arrivesInOneToThreeBusinessDays),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SCSectionHeader(
                label: Get.find<LanguageController>().getTranslation(
                  Strings.toLabel,
                ),
              ),
              _buildDestinationCard(bankName),
              const SizedBox(height: 20),
              SCSectionHeader(
                label: Get.find<LanguageController>().getTranslation(
                  Strings.breakdownLabel,
                ),
              ),
              _buildBreakdown(
                amount: amount,
                networkFee: networkFee,
                serviceFee: serviceFee,
                youReceive: youReceive,
              ),
              const Spacer(),
              Obx(
                () => SCPrimaryButton(
                  label: Get.find<LanguageController>()
                      .getTranslation(Strings.confirmWithdrawal),
                  loading: controller.isConfirmLoading,
                  onPressed: () => controller.confirmProcess(context),
                ),
              ),
              const SizedBox(height: 8),
              SCGhostButton(
                label: Get.find<LanguageController>()
                    .getTranslation(Strings.withdrawToADifferentBank),
                onPressed: () =>
                    Get.toNamed(Routes.moneyOutManualPaymentScreen),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroAmount(double amount) {
    final formatted = _fmt(amount);
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '.00';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          r'$',
          style: AppTextStyles.h2.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          intPart,
          style: AppTextStyles.display.copyWith(
            color: AppColors.text,
          ),
        ),
        Text(
          decPart,
          style: AppTextStyles.bodyMed.copyWith(
            color: AppColors.text2,
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard(String bankName) {
    return SCSurfaceCard(
      padding: const EdgeInsets.all(14),
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
            child: const Icon(
              Icons.account_balance_outlined,
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
                Text(
                  bankName.isEmpty
                      ? Get.find<LanguageController>()
                          .getTranslation(Strings.selectedDestination)
                      : bankName,
                  style: AppTextStyles.bodyMed.copyWith(
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '•••• 0000 · ${Get.find<LanguageController>().getTranslation(Strings.bankTransfer)}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          SCGhostButton(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.change),
            onPressed: Get.back,
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown({
    required double amount,
    required double networkFee,
    required double serviceFee,
    required double youReceive,
  }) {
    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _BreakdownRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.amount),
            value: '\$${_fmt(amount)}',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.networkFee),
            value: networkFee == 0
                ? Get.find<LanguageController>().getTranslation(Strings.free)
                : '\$${_fmt(networkFee)}',
            valueColor:
                networkFee == 0 ? AppColors.accent : AppColors.text,
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.serviceFee),
            value: '\$${_fmt(serviceFee)}',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Get.find<LanguageController>()
                .getTranslation(Strings.youllReceive),
            value: '\$${_fmt(youReceive)}',
            emphasised: true,
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.caption.copyWith(
      color: AppColors.text2,
      fontWeight: emphasised ? FontWeight.w600 : null,
    );
    final valueStyle = AppTextStyles.numMd.copyWith(
      color: valueColor ?? AppColors.text,
      fontWeight: emphasised ? FontWeight.w600 : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
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
