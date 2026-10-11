import "package:TAKARA PAY/base/utils/local_storage.dart";

import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_button.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_section_header.dart";
import "package:TAKARA PAY/base/widgets/design_system/sc_surface_card.dart";

class StripCardPreview extends StatelessWidget {
  StripCardPreview({super.key});

  final controller = Get.put(StripeTwoController());

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
          () => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : _bodyWidget(context),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            physics: const BouncingScrollPhysics(),
            children: [
              _amountWidget(context),
              const SizedBox(height: 28),
              const SCSectionHeader(label: 'AMOUNT INFORMATION'),
              previewInfo(),
            ],
          ),
        ),
        _buttonWidget(context),
      ],
    );
  }

  Widget previewInfo() {
    var _cardCharge = controller.stripeCardModel.data.cardCharge;
    var baseCurrency = controller.stripeCardModel.data.baseCurr;

    // Get user input amount
    double amount = double.parse(controller.fundAmountController.text);

    // Get exchange rate
    double exchangeRate = controller.selectedSupportedCurrencyRate.value;

    double normalizedExchangeRate =
        (controller.selectedSupportedCurrency.value == baseCurrency)
            ? exchangeRate
            : (1 / exchangeRate);

    double roundToFourDecimals(double value) {
      return double.parse(value.toStringAsFixed(4));
    }

    // Convert amount to base currency
    double convertedAmount =
        roundToFourDecimals(amount * normalizedExchangeRate);

    // Calculate percentage charge (1% of converted amount)
    double percentCharge = roundToFourDecimals(
        (convertedAmount / 100) * _cardCharge.percentCharge);

    // Calculate total charge (fixed charge + percent charge)
    double totalCharge =
        roundToFourDecimals(_cardCharge.fixedCharge + percentCharge);

    // Calculate total payable amount
    double totalPayable = roundToFourDecimals(convertedAmount + totalCharge);

    return SCSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InfoRow(
            label: Strings.enterAmount,
            value:
                '${amount.toStringAsFixed(4)} ${controller.selectedSupportedCurrency.value}',
          ),
          const _RowDivider(),
          _InfoRow(
            label: Strings.exchangeRate,
            value:
                '1 ${controller.selectedSupportedCurrency.value} = ${normalizedExchangeRate.toStringAsFixed(8)} ${LocalStorage.getBaseCurrency()}',
          ),
          const _RowDivider(),
          _InfoRow(
            label: Strings.totalCharge,
            value:
                '${totalCharge.toStringAsFixed(4)} ${LocalStorage.getBaseCurrency()}',
          ),
          const _RowDivider(),
          _InfoRow(
            label: Strings.totalPayable,
            value:
                '${totalPayable.toStringAsFixed(4)} ${LocalStorage.getBaseCurrency()}',
            emphasised: true,
          ),
        ],
      ),
    );
  }

  Widget _amountWidget(BuildContext context) {
    final amount =
        "${controller.fundAmountController.text} ${controller.selectedSupportedCurrency.value}";
    return Column(
      children: [
        Center(
          child: Text(
            Strings.amount.toUpperCase(),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            amount,
            style: AppTextStyles.numDisplay.copyWith(color: AppColors.text),
          ),
        ),
      ],
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Obx(
          () => SCPrimaryButton(
            label: Strings.buyNow,
            loading: controller.isBuyCardLoading,
            onPressed: () {
              controller.buyCardProcess(context);
            },
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
              textAlign: TextAlign.right,
              style: AppTextStyles.numSm.copyWith(
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
