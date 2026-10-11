import "package:TAKARA PAY/views/virtual_card_stripe/controller/stripe_two_controller.dart";

import "package:TAKARA PAY/base/api/model/virtual_card/stripe_models/stripe_transaction_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class StripeTransactionController extends GetxController {
  final controller = Get.put(StripeTwoController());
  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late StripeCardTransactionModel _stripeCardTransactionsModel;
  StripeCardTransactionModel get stripeCardTransactionsModel =>
      _stripeCardTransactionsModel;

  Future<StripeCardTransactionModel> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await ApiServices.stripeCardTransactionApi(controller.cardId.value)
        .then((value) {
      _stripeCardTransactionsModel = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _stripeCardTransactionsModel;
  }
}
