import 'package:flutter/material.dart';
import 'package:get/get.dart';

import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/utils/logger.dart";
import "package:stripcard/routes/routes.dart";
import "package:stripcard/base/utils/custom_color.dart";
import "package:stripcard/base/utils/custom_style.dart";
import "package:stripcard/base/utils/dimensions.dart";
import "package:stripcard/base/widgets/text_labels/custom_title_heading_widget.dart";
import "package:stripcard/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";

final log = logger(SudoAddFundController);

class SudoAddFundController extends GetxController {
  final virtualCardController = Get.put(VirtualSudoCardController());
  final amountTextController = TextEditingController();


  List<String> totalAmount = [];

  @override
  void dispose() {
    amountTextController.dispose();
    amountTextController.text = '0.0';

    super.dispose();
  }


  @override
  void onInit() {

    super.onInit();
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
  List currencyList = ['USD', 'BDT'];
  List gatewayList = ['Paypal', 'Stripe'];

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
        getFee(rate: virtualCardController.rate.value);
      },
      child: Center(
        child: CustomTitleHeadingWidget(
          text: keyboardItemList[index],
          style: Get.isDarkMode
              ? CustomStyle.lightHeading2TextStyle.copyWith(
                  fontSize: Dimensions.headingTextSize3 * 2,
                  color: CustomColor.whiteColor,
                )
              : CustomStyle.darkHeading2TextStyle.copyWith(
                  color: CustomColor.primaryLightColor,
                  fontSize: Dimensions.headingTextSize3 * 2,
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //                              Card Block Process
  // ---------------------------------------------------------------------------
  // -------------------------------Api Loading Indicator-----------------------
  //

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Api Loading Indicator-----------------------

  late CommonSuccessModel _cardCreateData;

  CommonSuccessModel get cardCreateData => _cardCreateData;

  Future<CommonSuccessModel> sudoAddFundProcess() async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {
      'card_id': virtualCardController.cardId.value,
      'fund_amount': amountTextController.text,
      'currency': virtualCardController.baseCurrency.value,
      'from_currency': virtualCardController.baseCurrency.value,
    };

    update();

    await ApiServices.sudoCardFundApi(body: inputBody).then((value) {
      _cardCreateData = value!;

      CustomSnackBar.success(_cardCreateData.message.success.first);
      Get.offAllNamed(Routes.bottomNavBarScreen);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardCreateData;
  }



  RxDouble getFee({required double rate}) {
    double value =
        virtualCardController.dashboardController.fixedCharge.value * rate;
    value = value +
        (double.parse(amountTextController.text.isEmpty
                ? '0.0'
                : amountTextController.text) *
            (virtualCardController.dashboardController.percentCharge.value /
                100));

    if (amountTextController.text.isEmpty) {
      virtualCardController.totalFee.value = 0.0;
    } else {
      virtualCardController.totalFee.value = value;
    }

    debugPrint(virtualCardController.totalFee.value.toStringAsPrecision(2));
    return virtualCardController.totalFee;
  }
}
