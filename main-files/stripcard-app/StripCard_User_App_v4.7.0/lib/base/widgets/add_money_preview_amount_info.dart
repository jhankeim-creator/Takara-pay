import "package:TAKARA PAY/views/app_settings/controller/app_settings_controller.dart";
import "package:TAKARA PAY/views/deposit/controller/deposit_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class AddMoneyPreviewAmountInfo extends StatelessWidget {
  AddMoneyPreviewAmountInfo({super.key});

  final depositController = Get.put(DepositController());
  final dashboardController = Get.put(DashBoardController());
  final appSettingController = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    double amount = depositController.amountController.text.isEmpty
        ? 0.0
        : double.parse(depositController.amountController.text);

    var conversionAmount = amount * depositController.supportedRate.value;
    // var percentageCharge = (1 / 100) * conversionAmount;
    var percentageCharge =
        depositController.supportedRate.value *
        (amount / 100) *
        depositController.percentCharge.value;
    var feesAndChargeResult =
        percentageCharge + depositController.selectedFee.value;
    double percentCharge =
        (amount / 100) * depositController.percentCharge.toDouble();
    double totalCharge =
        feesAndChargeResult +
        percentCharge * depositController.supportedRate.value;
    var totalPayableAmount = conversionAmount + feesAndChargeResult;

    return Container(
      margin: EdgeInsets.only(top: Dimensions.heightSize * 0.4),
      decoration: BoxDecoration(
        color: CustomColor.primaryLightColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.7,
              bottom: Dimensions.paddingSize * 0.3,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: TitleHeading3Widget(
              text: Strings.amountInformation,
              textAlign: TextAlign.left,
            ),
          ),
          Divider(
            thickness: 1,
            color: CustomColor.primaryLightScaffoldBackgroundColor,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.paddingSize * 0.3,
              bottom: Dimensions.paddingSize * 0.6,
              left: Dimensions.paddingSize * 0.7,
              right: Dimensions.paddingSize * 0.7,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.enterAmount,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          '${double.tryParse(depositController.amountController.text)?.toStringAsFixed(depositController.remainingController.dashboardController.precision.value)} ${depositController.baseCurrency}',
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.marginSizeVertical * 0.2),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.exchangeRate,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          " 1 ${depositController.baseCurrency.value} = ${depositController.supportedRate.value.toStringAsFixed(depositController.crypto.value == '1' ? appSettingController.cryptoPrecisionValue.value : appSettingController.fiatPrecisionValue.value)} ${depositController.code.value}",
                      textAlign: TextAlign.left,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.marginSizeVertical * 0.2),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.feesAndCharges,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          '${feesAndChargeResult.toStringAsFixed(depositController.crypto.value == '1' ? appSettingController.cryptoPrecisionValue.value : appSettingController.fiatPrecisionValue.value)} ${depositController.code.value}',
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.marginSizeVertical * 0.2),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.conversionAmount,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          '${conversionAmount.toStringAsFixed(depositController.remainingController.dashboardController.precision.value)} ${depositController.code.value}',
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.marginSizeVertical * 0.2),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.recipientReceived,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          '${amount.toStringAsFixed(dashboardController.precision.value)} ${depositController.baseCurrency}',
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                verticalSpace(Dimensions.marginSizeVertical * 0.2),
                Row(
                  mainAxisAlignment: mainSpaceBet,
                  children: [
                    TitleHeading4Widget(
                      text: Strings.totalPayable,
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    TitleHeading4Widget(
                      text:
                          '${totalPayableAmount.toStringAsFixed(depositController.crypto.value == '1' ? appSettingController.cryptoPrecisionValue.value : appSettingController.fiatPrecisionValue.value)} ${depositController.code.value}',
                      color: CustomColor.primaryLightTextColor.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
