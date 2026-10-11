import 'package:google_fonts/google_fonts.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/money_transfer/controller/money_transfer_controller.dart";
import "package:stripcard/views/money_transfer/controller/money_transfer_info_controller.dart";

class MoneyTransferAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MoneyTransferController controller =
        Get.find<MoneyTransferController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verticalSpace(Dimensions.marginSizeVertical * 0.3),
         
         
        TitleHeading3Widget(
          text: Strings.howMuchTransfer,
          fontSize: Dimensions.headingTextSize4,
          color: Get.isDarkMode
              ? CustomColor.primaryLightTextColor
              : CustomColor.primaryDarkTextColor,
        ),
 

        verticalSpace(Dimensions.marginSizeVertical * 0.3),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(Icons.remove, controller.decrement),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.marginSizeHorizontal,
                  ),
                  child: TextField(
                    controller: controller.amountController,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: Dimensions.headingTextSize1 + 2,
                      fontWeight: FontWeight.w800,
                      color: Get.isDarkMode
                          ? CustomColor.primaryLightTextColor
                          : CustomColor.primaryLightColor,
                    ),
                    cursorColor: CustomColor.primaryLightColor,

                    // Set input text color to red
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,

                      // hintText: Strings.zero00,

                      // hintStyle: GoogleFonts.inter(
                      //   fontSize: Dimensions.headingTextSize1 + 2,
                      //   fontWeight: FontWeight.w800,
                      //   color: Get.isDarkMode
                      //       ? CustomColor.primaryLightTextColor
                      //       : CustomColor.primaryLightColor,
                      // ),
                    ),

                    onChanged: (value) {
                      double? enteredValue = double.tryParse(value);
                      if (enteredValue != null) {
                        controller.amount.value = enteredValue;
                      }
                    },
                  ),
                ),
              ),
              _buildButton(Icons.add, controller.increment),
            ],
          ),
        ),
        verticalSpace(Dimensions.marginSizeVertical * 0.6),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: Dimensions.marginSizeVertical * 0.4,
            children: controller.presetAmounts.map((value) {
              bool isSelected = controller.amount.value == value;
              return GestureDetector(
                onTap: () {
                  controller.setAmount(value);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.marginSizeVertical * 0.2,
                    horizontal: Dimensions.marginSizeHorizontal * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColor.primaryLightColor
                        : Get.isDarkMode
                        ? CustomColor.primaryLightScaffoldBackgroundColor
                        : CustomColor.bgLightColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius * 2),
                    border: Border.all(
                      width: 0.75,
                      color: isSelected
                          ? Get.isDarkMode
                                ? CustomColor.grayColor
                                : CustomColor.whiteColor
                          : Get.isDarkMode
                          ? CustomColor.grayColor
                          : CustomColor.grayColor,
                    ),
                  ),
                  child: TitleHeading4Widget(
                    text: "\$$value",
                    color: isSelected
                        ? CustomColor.whiteColor
                        : CustomColor.grayColor,
                    fontWeight: FontWeight.w900,
                    fontSize: Dimensions.headingTextSize6,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  _buildButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 0.8),
          color: Get.isDarkMode
              ? CustomColor.bgLightColor.withValues(alpha: 0.15)
              : CustomColor.primaryLightColor.withValues(alpha: 0.15),
        ),
        child: Icon(
          icon,
          size: Dimensions.headingTextSize3,
          color: CustomColor.grayColor,
        ),
      ),
    );
  }
}

class TransactionDetailsWidget extends StatelessWidget {
  final controller = Get.put(MoneyTransferController());
  final infoController = Get.put(MoneyTransferInfoController());

  @override
  Widget build(BuildContext context) {
    var data = infoController.transferMoneyInfoModel.data.transferMoneyCharge;
    var baseCurrency = infoController.transferMoneyInfoModel.data.baseCurr;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.5,
        horizontal: Dimensions.marginSizeHorizontal * 0.5,
      ),
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.5,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryLightScaffoldBackgroundColor
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildDetailRow(
          //     Strings.rate,
          //     '${data.minLimit.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} ${baseCurrency} - ${data.maxLimit.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} $baseCurrency',
          //     CustomColor.grayColor),
          _buildDetailRow(
            Strings.limit,
            '${data.minLimit.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} ${baseCurrency} - ${data.maxLimit.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} $baseCurrency',
            Get.isDarkMode ? CustomColor.grayColor : CustomColor.grayColor,
          ),
          _buildDetailRow(
            Strings.charge,
            '${data.fixedCharge.toStringAsFixed(controller.remainingController.dashboardController.precision.value)} ${baseCurrency} + 1%',
            CustomColor.grayColor,
          ),
        ],
      ),
    );
  }

  _buildDetailRow(String title, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.2,
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: color),
          horizontalSpace(Dimensions.marginSizeHorizontal * 0.4),
          TitleHeading4Widget(
            text: title,
            color: Get.isDarkMode
                ? CustomColor.primaryLightTextColor
                : CustomColor.primaryDarkTextColor.withAlpha(55),
            fontWeight: FontWeight.bold,
          ),
          horizontalSpace(Dimensions.marginSizeHorizontal * 0.2),
          Expanded(
            child: TitleHeading4Widget(
              text: value,
              fontWeight: FontWeight.w900,
              color: Get.isDarkMode
                  ? CustomColor.primaryLightTextColor
                  : CustomColor.primaryDarkTextColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
