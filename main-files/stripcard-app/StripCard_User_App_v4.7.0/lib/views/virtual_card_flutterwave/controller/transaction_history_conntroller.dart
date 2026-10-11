import "package:TAKARA PAY/base/api/model/virtual_card/card_transaction_history_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";

class TransactionHistoryController extends GetxController {
  final controller = Get.put(FlutterWaveCardController());
  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late CardTransactionsModel _cardTransactionsModel;
  CardTransactionsModel get cardTransactionsModel => _cardTransactionsModel;

  Future<CardTransactionsModel> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await ApiServices.cardTransactionApi(controller.cardId.value).then((value) {
      _cardTransactionsModel = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardTransactionsModel;
  }
}
