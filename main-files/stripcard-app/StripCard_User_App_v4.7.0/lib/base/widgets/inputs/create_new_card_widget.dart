import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/base/widgets/inputs/primary_input_filed.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/widgets/others/custom_image_widget.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutter_wave_card_create_controller.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";
import "package:stripcard/custom_assets/assets.gen.dart";
import "package:stripcard/base/utils/language/strings.dart";
import "package:stripcard/base/utils/basic_widget_import.dart";
import "package:stripcard/base/widgets/buttons/primary_button.dart";
import "package:stripcard/base/widgets/others/flutter_wave_currency/flutter_wave_currency.dart";
import "package:stripcard/base/widgets/others/limit_information_widget (1).dart";

class CustomCreateAmountWidget extends StatelessWidget {
  final createCardKey = GlobalKey<FormState>();

  CustomCreateAmountWidget({
    Key? key,
    required this.buttonText,
  }) : super(key: key);
  final String buttonText;
  final controller = Get.put(FlutterWaveCardController());
  final cardChargeController = Get.put(CreateCardController());
  final remainingController = Get.put(RemainingBalanceController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  _bodyWidget(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // _inputFieldWidget(context),
          // _customNumKeyBoardWidget(context),
          _inputFieldWidget(context),
          _limitInfoShow(),
          _buttonWidget(context)
        ],
      ),
    );
  }

  _limitInfoShow() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.5,
      ),
      child: Obx(
        () => LimitInformationWidget(
          transactionLimit:
              '${controller.limitMin.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value} - ${controller.limitMax.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value}',
          dailyLimit:
              '${controller.dailyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value}',
          remainingDailyLimit:
              '${controller.getRemainingDailyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value}',
          monthlyLimit:
              '${controller.monthlyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value}',
          remainingMonthLimit:
              '${controller.getRemainingMonthlyLimit.value.toStringAsFixed(remainingController.dashboardController.precision.value)} ${controller.selectedSupportedCurrencyCode.value}',
        ),
      ),
    );
  }

  _inputFieldWidget(BuildContext context) {
    var data = controller.dashboardController.dashBoardModel.data;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.5,
          vertical: Dimensions.marginSizeVertical * 0.5),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          PrimaryInputWidget(
              controller: controller.cardAmountTextController,
              hint: Strings.amount,
              keyboardInputType: TextInputType.number,
              label: Strings.cardAmount),
          verticalSpace(Dimensions.marginBetweenInputBox),
          FlutterWaveCurrency(
            itemsList: controller.supportedCurrencyList,
            selectMethod: controller.selectedSupportedCurrencyCode,
            onChanged: (type) {
              controller.selectedSupportedCurrencyName.value =
                  type!.currencyName;
              controller.selectedSupportedCurrencyCode.value =
                  type.currencyCode;
              controller.selectedSupportedCurrencyRate.value = type.rate;

              // controller.exchangeRate.value = type.rate;

              print(controller.selectedSupportedCurrencyCode.value);
              print(controller.selectedSupportedCurrencyRate.value);
            },
          ),
        ],
      ),
    );
  }

  // _inputFieldWidget(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.only(
  //       right: Dimensions.marginSizeHorizontal * 0.5,
  //       top: Dimensions.marginSizeVertical * 2,
  //     ),
  //     alignment: Alignment.topCenter,
  //     height: Dimensions.inputBoxHeight,
  //     width: double.infinity,
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(
  //           width: MediaQuery.of(context).size.width * 0.45,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SizedBox(width: Dimensions.widthSize * 0.7),
  //               Expanded(
  //                 child: TextFormField(
  //                   style: Get.isDarkMode
  //                       ? CustomStyle.lightHeading2TextStyle.copyWith(
  //                           fontSize: Dimensions.headingTextSize3 * 2,
  //                         )
  //                       : CustomStyle.darkHeading2TextStyle.copyWith(
  //                           color: CustomColor.primaryTextColor,
  //                           fontSize: Dimensions.headingTextSize3 * 2,
  //                         ),
  //                   readOnly: true,
  //                   controller: controller.amountTextController,
  //                   keyboardType:
  //                       const TextInputType.numberWithOptions(decimal: true),
  //                   inputFormatters: <TextInputFormatter>[
  //                     FilteringTextInputFormatter.allow(
  //                         RegExp(r'(^-?\d*\.?\d*)')),
  //                     LengthLimitingTextInputFormatter(
  //                       6,
  //                     ),
  //                   ],
  //                   validator: (String? value) {
  //                     if (value!.isEmpty) {
  //                       return Strings.pleaseFillOutTheField;
  //                     } else {
  //                       return null;
  //                     }
  //                   },
  //                   decoration: const InputDecoration(
  //                     enabledBorder: InputBorder.none,
  //                     focusedBorder: InputBorder.none,
  //                     errorBorder: InputBorder.none,
  //                     focusedErrorBorder: InputBorder.none,
  //                     contentPadding: EdgeInsets.zero,
  //                     hintText: '0.0',
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: Dimensions.widthSize * 0.5,
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(width: Dimensions.widthSize * 0.7),
  //         _currencyDropDownWidget(context),
  //       ],
  //     ),
  //   );
  // }
  //
  // _customNumKeyBoardWidget(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 6),
  //     child: GridView.count(
  //       physics: const NeverScrollableScrollPhysics(),
  //       crossAxisCount: 3,
  //       crossAxisSpacing: 10.0,
  //       mainAxisSpacing: 10.0,
  //       childAspectRatio: 3 / 1.7,
  //       shrinkWrap: true,
  //       children: List.generate(
  //         controller.keyboardItemList.length,
  //         (index) {
  //           return controller.inputItem(index);
  //         },
  //       ),
  //     ),
  //   );
  // }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              title: buttonText,
              onPressed: () {
                if (controller.cardAmountTextController.text.isNotEmpty) {
                  cardChargeController.goToCreateNewCardPreviewScreen();
                } else {
                  CustomSnackBar.error(Strings.plzEnterAmount);
                }
              },
              borderColor: Theme.of(context).primaryColor,
              buttonColor: CustomColor.primaryLightColor,
            ),
          ),
        ],
      ),
    );
  }

  _currencyDropDownWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: Dimensions.buttonHeight * 0.65,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.1,
          vertical: Dimensions.marginSizeVertical * 0.2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 3),
          color: CustomColor.primaryBGDarkColor),
      child: Row(children: [
        SizedBox(
          width: Dimensions.widthSize,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
          child: CustomImageWidget(
            path: Assets.qr.usa.path,
            height: Dimensions.heightSize * 2.3,
            width: Dimensions.widthSize * 2.3,
            color: Colors.blue,
          ),
        ),
        horizontalSpace(Dimensions.widthSize),
        TitleHeading3Widget(
          text: LocalStorage.getBaseCurrency() ?? 'USD',
          color: CustomColor.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      ]),
    );
  }
}
