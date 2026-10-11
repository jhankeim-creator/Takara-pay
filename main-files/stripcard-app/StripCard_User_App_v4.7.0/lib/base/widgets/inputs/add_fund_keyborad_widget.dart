import 'dart:io';
import 'package:flutter/services.dart';
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/base/widgets/others/limit_widget.dart";
import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/widgets/others/custom_image_widget.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/adfund_controller.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutter_wave_card_create_controller.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_heading5_widget.dart";

class AddFundWidget extends StatelessWidget {
  AddFundWidget({
    Key? key,
    required this.buttonText,
  }) : super(key: key);
  final String buttonText;
  final controller = Get.put(AddFundController());
  final cardChargesController = Get.put(CreateCardController());
  final dashBoardController = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => cardChargesController.isLoading
          ? CustomLoadingAPI()
          : _bodyWidget(context),
    );
  }

  _bodyWidget(BuildContext context) {
    var data = cardChargesController.cardChargesModel.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _inputFieldWidget(context),
        limitWidget(
            fee:
                "${dashBoardController.fixedCharge.value} ${data.baseCurr} + ${dashBoardController.percentCharge.value} %",
            limit:
                "${dashBoardController.limitMin.value} ${data.baseCurr} - ${dashBoardController.limitMax.value} ${data.baseCurr}"),
        _customNumKeyBoardWidget(context),
        // Text('${dashBoardController.}')
        _dallyAndMonthlyLimit(context),
        _buttonWidget(context)
      ],
    );
  }

  _inputFieldWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeHorizontal * 0.5,
        top: Dimensions.marginSizeVertical * 2,
      ),
      alignment: Alignment.topCenter,
      height: Dimensions.inputBoxHeight,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: Dimensions.widthSize * 0.7),
                  Expanded(
                    child: TextFormField(
                      style: Get.isDarkMode
                          ? CustomStyle.lightHeading2TextStyle.copyWith(
                              fontSize: Dimensions.headingTextSize3 * 2,
                            )
                          : CustomStyle.darkHeading2TextStyle.copyWith(
                              color: CustomColor.primaryTextColor,
                              fontSize: Dimensions.headingTextSize3 * 2,
                            ),
                      readOnly: true,
                      controller: controller.amountTextController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*\.?\d*)')),
                        LengthLimitingTextInputFormatter(
                          6,
                        ),
                      ],
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return Strings.pleaseFillOutTheField;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0.0',
                        hintStyle: CustomStyle.darkHeading2TextStyle.copyWith(
                          color: CustomColor.primaryTextColor
                              .withValues(alpha: 0.7),
                          fontSize: Dimensions.headingTextSize3 * 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.widthSize * 0.5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: Dimensions.widthSize * 0.7),
          _currencyDropDownWidget(context),
        ],
      ),
    );
  }

  _customNumKeyBoardWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 5),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3 / 1.7,
        shrinkWrap: true,
        children: List.generate(
          controller.keyboardItemList.length,
          (index) {
            return controller.inputItem(index);
          },
        ),
      ),
    );
  }

  _dallyAndMonthlyLimit(BuildContext context) {
    return Column(
      children: [
        TitleHeading5Widget(
          text:
              '${Strings.dailyLimit}${controller.controller.dailyLimit} ${controller.controller.baseCurrency.value}',
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w500,
          color: Get.isDarkMode
              ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
              : Theme.of(context).primaryColor.withValues(alpha: 0.6),
        ),
        TitleHeading5Widget(
          text:
              '${Strings.monthlyLimit}${controller.controller.monthlyLimit} ${controller.controller.baseCurrency.value}',
          textAlign: TextAlign.left,
          fontWeight: FontWeight.w500,
          color: Get.isDarkMode
              ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
              : Theme.of(context).primaryColor.withValues(alpha: 0.6),
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              title: buttonText,
              onPressed: () {
                if (controller.amountTextController.text.isNotEmpty) {
                  Get.toNamed(Routes.addFundPreviewScreen);
                } else {
                  CustomSnackBar.error(Strings.plzEnterAmount);
                }
              },
              borderColor: CustomColor.primaryLightColor,
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
