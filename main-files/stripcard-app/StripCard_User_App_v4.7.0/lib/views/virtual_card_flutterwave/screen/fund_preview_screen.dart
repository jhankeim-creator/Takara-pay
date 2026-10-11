import "package:stripcard/views/virtual_card_flutterwave/controller/flutter_wave_card_create_controller.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/adfund_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/design_system/sc_section_header.dart";
import "package:stripcard/base/widgets/design_system/sc_surface_card.dart";

class AddFundPreviewScreen extends StatelessWidget {
  AddFundPreviewScreen({super.key});

  final controller = Get.put(AddFundController());
  final cardChargesController = Get.put(CreateCardController());

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
          Strings.preview,
          style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => cardChargesController.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    final data = cardChargesController.cardChargesModel.data;
    final cardCharge = data.cardCharge;

    final double amount =
        double.tryParse(controller.amountTextController.text) ?? 0;
    final double fixedCharge =
        double.tryParse(cardCharge.fixedCharge.toString()) ?? 0;
    final double percentCharge =
        (amount / 100) * cardCharge.percentCharge;
    final double totalCharge = fixedCharge + percentCharge;
    final double totalPayable = amount + totalCharge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              Strings.enterAmount.toUpperCase(),
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(height: 12),
          _buildHeroAmount(amount, data.baseCurr),
          const SizedBox(height: 32),
          const SCSectionHeader(label: 'AMOUNT INFORMATION'),
          _buildBreakdown(
            baseCurr: data.baseCurr,
            amount: amount,
            totalCharge: totalCharge,
            totalPayable: totalPayable,
          ),
          const Spacer(),
          Obx(
            () => SCPrimaryButton(
              label: Strings.confirm,
              loading: controller.isLoading,
              onPressed: () {
                controller.addFundProcess(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeroAmount(double amount, String baseCurr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          amount.toStringAsFixed(2),
          style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
        ),
        const SizedBox(width: 6),
        Text(
          baseCurr,
          style: AppTextStyles.h2.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }

  Widget _buildBreakdown({
    required String baseCurr,
    required double amount,
    required double totalCharge,
    required double totalPayable,
  }) {
    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _BreakdownRow(
            label: Strings.exchangeRate,
            value: '1 $baseCurr = 1 $baseCurr',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Strings.enterAmount,
            value: '${controller.amountTextController.text} $baseCurr',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Strings.transferFee,
            value: '$totalCharge $baseCurr',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Strings.recipientReceived,
            value: '${amount.toStringAsFixed(2)} $baseCurr',
          ),
          const _RowDivider(),
          _BreakdownRow(
            label: Strings.totalPayable,
            value: '$totalPayable $baseCurr',
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
    this.emphasised = false,
  });

  final String label;
  final String value;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.caption.copyWith(
      color: AppColors.text2,
      fontWeight: emphasised ? FontWeight.w600 : null,
    );
    final valueStyle = AppTextStyles.numMd.copyWith(
      color: AppColors.text,
      fontWeight: emphasised ? FontWeight.w600 : null,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: labelStyle)),
          const SizedBox(width: 12),
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
      color: AppColors.line2,
    );
  }
}
