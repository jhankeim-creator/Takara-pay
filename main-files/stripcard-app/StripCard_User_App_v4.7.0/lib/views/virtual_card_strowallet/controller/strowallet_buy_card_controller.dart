import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:stripcard/routes/routes.dart";
import "package:stripcard/base/utils/custom_color.dart";
import "package:stripcard/base/utils/custom_style.dart";
import "package:stripcard/base/utils/dimensions.dart";
import "package:stripcard/base/widgets/text_labels/custom_title_heading_widget.dart";
import "package:stripcard/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";

class StrowalletBuyController extends GetxController {
  final amountTextController = TextEditingController();
  List<String> totalAmount = [];

  // RxString selectCurrency = 'USD'.obs;
  // RxString selectWallet = 'Paypal'.obs;

  final controller = Get.put(VirtualStrowalletCardController());

  @override
  void dispose() {
    amountTextController.dispose();

    super.dispose();
  }

  goToAddMoneyPreviewScreen() {
    Get.toNamed(Routes.addFundPreviewScreen);
  }

  goToAddMoneyCongratulationScreen() {
    Get.toNamed(Routes.addFundPreviewScreen);
  }

  RxString selectItem = ''.obs;
  List<String> keyboardItemList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<'
  ];
  // List currencyList = ['USD', 'BDT'];
  // List gatewayList = ['Paypal', 'Stripe'];

  inputItem(int index) {
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onLongPress: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.clear();
            amountTextController.text = totalAmount.join('');
          } else {
            return;
          }
        }
      },
      onTap: () {
        if (index == 11) {
          if (totalAmount.isNotEmpty) {
            totalAmount.removeLast();
            amountTextController.text = totalAmount.join('');
          } else {
            return;
          }
        } else {
          if (totalAmount.contains('.') && index == 9) {
            return;
          } else {
            totalAmount.add(keyboardItemList[index]);
            amountTextController.text = totalAmount.join('');
            debugPrint(totalAmount.join(''));
          }
        }
      },
      child: Center(
        child: CustomTitleHeadingWidget(
          text: keyboardItemList[index],
          style: Get.isDarkMode
              ? CustomStyle.lightHeading2TextStyle.copyWith(
                  fontSize: Dimensions.headingTextSize3 * 2,
                )
              : CustomStyle.darkHeading2TextStyle.copyWith(
                  color: CustomColor.primaryTextColor,
                  fontSize: Dimensions.headingTextSize3 * 2,
                ),
        ),
      ),
    );
  }
}
