import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_add_fund_controller.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";

class AddFundCardyfiePreviewScreen extends StatelessWidget {
  AddFundCardyfiePreviewScreen({super.key});
  final controller = Get.put(CardyfieAddFundController());
  final walletController = Get.put(VirtualCardyfieCardController());
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
      body: SafeArea(child: _bodyWidget(context)),
    );
  }

  _bodyWidget(BuildContext context) {
    final amount =
        double.tryParse(controller.amountTextController.text) ?? 0.0;
    final totalCharge = walletController.totalCharges.value;
    final totalAmount = amount + totalCharge;
    final currency = walletController.baseCurrency.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Text(
              Strings.addFund,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(height: 12),
          _heroAmount(amount, currency),
          const SizedBox(height: 32),
          const SCSectionHeader(label: 'BREAKDOWN'),
          SCSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _BreakdownRow(
                  label: Strings.amountInformation,
                  value: '${amount.toStringAsFixed(2)} $currency',
                ),
                const _RowDivider(),
                _BreakdownRow(
                  label: Strings.totalCharge,
                  value: '${totalCharge.toStringAsFixed(2)} $currency',
                ),
                const _RowDivider(),
                _BreakdownRow(
                  label: Strings.totalPay,
                  value: '${totalAmount.toStringAsFixed(2)} $currency',
                  emphasised: true,
                ),
              ],
            ),
          ),
          const Spacer(),
          _buttonWidget(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _heroAmount(double amount, String currency) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            amount.toStringAsFixed(2),
            style: AppTextStyles.display.copyWith(color: AppColors.text),
          ),
          const SizedBox(width: 6),
          Text(
            currency,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.text2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Obx(
      () => controller.isLoading
          ? const CustomLoadingAPI()
          : SCPrimaryButton(
              label: Strings.confirm,
              onPressed: () {
                controller.addFundProcess(context);
              },
            ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: emphasised ? FontWeight.w600 : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.numMd.copyWith(
              color: AppColors.text,
              fontWeight: emphasised ? FontWeight.w600 : null,
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
    return const Divider(height: 0.5, thickness: 0.5, color: AppColors.line);
  }
}
