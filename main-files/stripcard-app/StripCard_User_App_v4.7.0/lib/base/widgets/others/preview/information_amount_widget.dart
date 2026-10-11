import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";

import "package:TAKARA PAY/views/virtual_card_sudo/controller/create_card/sudo_create_card_controller.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/base/themes/app_colors.dart";
import "package:TAKARA PAY/base/themes/app_radius.dart";
import "package:TAKARA PAY/base/themes/app_text_styles.dart";

// ── Shared design-system "amount information" preview card ────────────────────
// A single source of truth for the breakdown card used across preview screens.
// Background/typography use the StripCard design tokens (no legacy purple).
Widget _infoCard(String title, List<List<String>> rows) {
  return Container(
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
      color: AppColors.surface,
      border: Border.all(color: AppColors.line2, width: 1),
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Text(
            title,
            style: AppTextStyles.bodyMed.copyWith(color: AppColors.text),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.line2),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            children: [
              for (int i = 0; i < rows.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        Get.find<LanguageController>()
                            .getTranslation(rows[i][0]),
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.text2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        rows[i][1],
                        textAlign: TextAlign.end,
                        style: AppTextStyles.numMd
                            .copyWith(color: AppColors.text),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

extension AmountInformation on Widget {
  Widget amountInformationWidget({
    required information,
    required enterAmount,
    required enterAmountRow,
    required fee,
    required feeRow,
    required exChange,
    required exChangeRow,
    received,
    receivedRow,
    total,
    totalRow,
  }) {
    final rows = <List<String>>[
      ['$enterAmount', '$enterAmountRow'],
      ['$exChange', '$exChangeRow'],
      ['$fee', '$feeRow'],
      if (received != null && receivedRow != null)
        ['$received', '$receivedRow'],
      if (total != null && totalRow != null) ['$total', '$totalRow'],
    ];
    return _infoCard('$information', rows);
  }
}

class AmountPreviewInfoWidget extends StatelessWidget {
  AmountPreviewInfoWidget({super.key});

  final controller = Get.put(SudoCreateCardController());
  final sudoController = Get.put(VirtualSudoCardController());
  final dashboardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    var cardCharge = controller.cardChargesModel.data.cardCharge;
    var baseCurrency = controller.cardChargesModel.data.baseCurr;

    // Get exchange rate
    double exchangeRate = controller.sudoCardController.exchangeRate.value;

    // Get user input amount
    double amount = double.parse(controller.amountTextController.text);

    double roundToFourDecimals(double value) {
      return double.parse(value.toStringAsFixed(4));
    }

    // Convert amount to base currency
    double convertedAmount = roundToFourDecimals(amount * exchangeRate);

    // Calculate percentage charge
    double percentCharge =
        roundToFourDecimals((convertedAmount / 100) * cardCharge.percentCharge);

    // Calculate total charge
    double totalCharge =
        roundToFourDecimals(cardCharge.fixedCharge + percentCharge);

    // Calculate total payable amount
    double totalPayable = roundToFourDecimals(convertedAmount + totalCharge);

    final p = dashboardController.precision.value;
    final code = controller.sudoCardController.selectedSupportedCurrencyCode.value;

    return _infoCard(Strings.amountInformation, [
      [
        Strings.enterAmount,
        '${double.tryParse(controller.amountTextController.text)?.toStringAsFixed(p) ?? '0.00'} $code',
      ],
      [
        Strings.exchangeRate,
        '1 $code = ${controller.sudoCardController.exchangeRate.toStringAsFixed(8)} $baseCurrency',
      ],
      [
        Strings.transferFee,
        '${cardCharge.fixedCharge.toStringAsFixed(p)} $baseCurrency',
      ],
      [
        Strings.recipientReceived,
        '${amount.toStringAsFixed(p)} $baseCurrency',
      ],
      [
        Strings.totalCharge,
        '${totalCharge.toStringAsFixed(p)} $baseCurrency',
      ],
      [
        Strings.totalPayable,
        '${totalPayable.toStringAsFixed(p)} $baseCurrency',
      ],
    ]);
  }
}
