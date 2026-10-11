import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";

import "package:TAKARA PAY/views/gift_card/controller/all_gift_card_controller.dart";
import "package:TAKARA PAY/views/gift_card/controller/create_gift_card_controller.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

/// Order summary card shown on the gift-card preview screen — redesigned to
/// match the app's design system (surface card + design tokens) instead of the
/// old solid-purple block. Labels resolve through the language controller.
class GifCardPreviewInfoWidget extends StatelessWidget {
  GifCardPreviewInfoWidget({super.key});

  final controller = Get.put(CreateGiftCardController());
  final allGiftController = Get.put(AllGiftCardController());
  final remainingController = Get.put(RemainingBalanceController());

  String _t(String key) => Get.find<LanguageController>().getTranslation(key);

  int get _precision => remainingController.dashboardController.precision.value;

  /// Selected amount, safe for both FIXED (denomination chips) and RANGE
  /// (free-text amount) cards — the old code indexed the denomination list
  /// directly, which threw a RangeError for RANGE products (empty list).
  double get _amount {
    final denoms =
        controller.giftCardDetailsModel.data.product.fixedRecipientDenominations;
    final idx = controller.selectedIndex.value;
    if (denoms.isNotEmpty && idx >= 0 && idx < denoms.length) {
      return double.tryParse('${denoms[idx]}') ?? 0.0;
    }
    return double.tryParse(controller.amountController.text) ?? 0.0;
  }

  String get _amountStr =>
      '${_amount.toStringAsFixed(_precision)} ${LocalStorage.getBaseCurrency()}';

  @override
  Widget build(BuildContext context) {
    final base = LocalStorage.getBaseCurrency();
    final exRate =
        controller.exRate.value.toStringAsFixed(_precision);
    final transferFee =
        controller.FixedCharge.value.toStringAsFixed(_precision);
    // Total Charge = fixed + percent charge (the computed total fees), NOT the
    // bare amount — the row previously mis-displayed the amount, so it never
    // matched the web "Total Fees & Charges".
    final totalChargeStr =
        '${controller.totalCharge.value.toStringAsFixed(_precision)} $base';
    final totalPayable =
        '${controller.totalPay.value.toStringAsFixed(_precision)} $base';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded,
                  size: 16, color: AppColors.text3),
              const SizedBox(width: 8),
              Text(
                _t(Strings.amountInformation),
                style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _divider(),
          const SizedBox(height: 12),
          _row(_t(Strings.productName), allGiftController.productName.value),
          _row(_t(Strings.receiverEmail),
              controller.receiverEmailController.text),
          _row(_t(Strings.receiverCountry), controller.selectedCountry.value),
          _row(_t(Strings.receiverPhone),
              controller.phoneNumberController.text),
          _row(_t(Strings.fromName), controller.fromNameController.text),
          _row(_t(Strings.unitPrice), _amountStr),
          _row(_t(Strings.quantity), controller.quantityController.text),
          _row(_t(Strings.conversionAmount), _amountStr),
          _row(_t(Strings.totalCharge), totalChargeStr),
          _row(_t(Strings.exchangeRate),
              '1 $base = $exRate ${controller.selectedCountryCode.value}'),
          _row(_t(Strings.transferFee), transferFee),
          const SizedBox(height: 6),
          _divider(),
          const SizedBox(height: 10),
          _row(_t(Strings.totalPayable), totalPayable, emphasize: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: (emphasize ? AppTextStyles.bodyMed : AppTextStyles.body)
                  .copyWith(
                color: emphasize ? AppColors.text : AppColors.text3,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              style: (emphasize ? AppTextStyles.numMd : AppTextStyles.bodyMed)
                  .copyWith(
                color: emphasize ? AppColors.accent : AppColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 1, color: AppColors.line2);
}
