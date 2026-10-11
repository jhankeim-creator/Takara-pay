import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import "package:TAKARA PAY/base/utils/custom_color.dart";
import "package:TAKARA PAY/base/utils/custom_style.dart";
import "package:TAKARA PAY/base/utils/dimensions.dart";
import "package:TAKARA PAY/base/utils/custom_loading_api.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_adfund_controller.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/base/utils/size.dart";
import "package:TAKARA PAY/base/widgets/buttons/primary_button.dart";
import "package:TAKARA PAY/base/widgets/dropdown/limit_widget.dart";
import "package:TAKARA PAY/base/widgets/text_labels/custom_title_heading_widget.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_heading4_widget.dart";
import "package:TAKARA PAY/base/widgets/text_labels/title_heading5_widget.dart";

class SudoAddFundCustomAmountWidget extends StatelessWidget {
  SudoAddFundCustomAmountWidget({
    Key? key,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);
  final String buttonText;
  final VoidCallback onTap;
  final controller = Get.put(SudoAddFundController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  _bodyWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _inputFieldWidget(context),
        _chargeAndFee(context),
        _remainingLimit(context),
        _customNumKeyBoardWidget(context),
        _buttonWidget(context)
      ],
    );
  }

  _remainingLimit(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: mainCenter,
          children: [
            TitleHeading5Widget(
              text: Strings.remainingDailyLimit,
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.6),
            ),
            TitleHeading5Widget(
              text:
                  "${controller.virtualCardController.remainingController.remainingDailyLimit.toStringAsFixed(controller.virtualCardController.dashboardController.precision.value)} ${controller.virtualCardController.baseCurrency.value}",
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.6),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: mainCenter,
          children: [
            TitleHeading5Widget(
              text: Strings.remainingDailyLimit,
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.6),
            ),
            TitleHeading5Widget(
              text:
                  "${controller.virtualCardController.remainingController.remainingDailyLimit.toStringAsFixed(controller.virtualCardController.dashboardController.precision.value)} ${controller.virtualCardController.baseCurrency.value}",
              textAlign: TextAlign.left,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withValues(alpha: 0.8)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.6),
            ),
          ],
        ),
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
            width: MediaQuery.of(context).size.width * 0.60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: Dimensions.widthSize * 0.7),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      style: Get.isDarkMode
                          ? CustomStyle.lightHeading2TextStyle.copyWith(
                              fontSize: Dimensions.headingTextSize3 * 2,
                              color: CustomColor.whiteColor,
                            )
                          : CustomStyle.darkHeading2TextStyle.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.headingTextSize3 * 2,
                            ),
                      readOnly: true,
                      controller: controller.amountTextController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*\.?\d*)')),
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return null;
                        } else {
                          return Strings.pleaseFillOutTheField;
                        }
                      },
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
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
          SizedBox(width: Dimensions.widthSize * 0.7),
          _currencyDropDownWidget(context),
        ],
      ),
    );
  }

  _customNumKeyBoardWidget(BuildContext context) {
    return GridView.count(
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
    );
  }

  _chargeAndFee(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: mainCenter,
          children: [
            LimitWidget(
              fee:
                  '${controller.virtualCardController.totalFee.value.toStringAsFixed(controller.virtualCardController.dashboardController.precision.value)} ${controller.virtualCardController.baseCurrency.value}',
            ),
          ],
        ));
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: mainCenter,
        children: [
          Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : Expanded(
                    child: PrimaryButton(
                      title: buttonText,
                      onPressed: onTap,
                      borderColor: Theme.of(context).primaryColor,
                      buttonColor: Theme.of(context).primaryColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _currencyDropDownWidget(BuildContext context) {
    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width * 0.21,
        height: Dimensions.buttonHeight * 0.65,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeHorizontal * 0.1,
            vertical: Dimensions.marginSizeVertical * 0.2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius * 3),
            color: Theme.of(context).primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Dimensions.widthSize * 0.5,
            ),
            SizedBox(
              width: Dimensions.widthSize * 0.4,
            ),
            DropdownButton(
              underline: Container(),
              hint: TitleHeading4Widget(
                text: controller.virtualCardController.baseCurrency.value,
                fontSize: Dimensions.headingTextSize2,
                color: CustomColor.whiteColor,
                fontWeight: FontWeight.w500,
              ),
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: CustomColor.whiteColor,
              ),
              items: controller.virtualCardController.baseCurrencyList
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 40.h,
                    child: Row(
                      children: [
                        CustomTitleHeadingWidget(
                          text: value.toString(),
                          style: GoogleFonts.inter(
                            color: controller.virtualCardController.baseCurrency
                                        .value ==
                                    value
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColor,
                            fontSize: Dimensions.headingTextSize3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                controller.virtualCardController.baseCurrency.value = value!;
              },
            ),
          ],
        ),
      );
    });
  }
}
