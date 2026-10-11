import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";

import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/services/cardyfie_api_services.dart";
import "package:stripcard/base/api/method/api_method.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_cardyfie/model/my_card_model_cardyfie.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";

class CardyfieWithdrawFundController extends GetxController {
  final amountTextController = TextEditingController();
  List<String> totalAmount = [];
  final controller = Get.put(VirtualCardyfieCardController());

  @override
  void dispose() {
    amountTextController.dispose();

    super.dispose();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // add fund  process
  late CommonSuccessModel _addMoneyModel;

  CommonSuccessModel get addMoneyModel => _addMoneyModel;

  Future<CommonSuccessModel> cardWithdrawProcess(context) async {
    _isLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'card_id': controller.cardyfieCardUIId.value,
      'withdraw_amount': int.parse(amountTextController.text.trim()),
      'currency': controller.supportedCurrencyCode.value,
      'from_currency': controller.fromCurrency.value,
    };
    await CardyfieApiServices.cardyfieCardWithdrawApi(body: inputBody)
        .then((value) {
          _addMoneyModel = value!;
          update();
          StatusScreen.show(
            context: context,
            subTitle: Strings.yourMoneyWithdrawSuccess.tr,
            onPressed: () {
              Get.offAllNamed(Routes.bottomNavBarScreen);
            },
          );
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
        });

    _isLoading.value = false;
    update();
    return _addMoneyModel;
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
    '<',
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
      },
      child: Center(
        child: CustomTitleHeadingWidget(
          text: keyboardItemList[index],
          style: Get.isDarkMode
              ? CustomStyle.lightHeading2TextStyle.copyWith(
                  color: CustomColor.primaryTextColor,
                  fontSize: Dimensions.headingTextSize3 * 2,
                )
              : CustomStyle.darkHeading2TextStyle.copyWith(
                  color: CustomColor.primaryDarkTextColor,
                  fontSize: Dimensions.headingTextSize3 * 2,
                ),
        ),
      ),
    );
  }
}
