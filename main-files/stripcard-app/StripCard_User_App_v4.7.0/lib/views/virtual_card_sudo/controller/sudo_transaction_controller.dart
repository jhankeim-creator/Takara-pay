import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_transaction_history_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";

class SudoTransactionController extends GetxController {
  final controller = Get.put(VirtualSudoCardController());

  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late SudoCardTransactionsModel _cardTransactionsModel;

  SudoCardTransactionsModel get cardTransactionsModel => _cardTransactionsModel;

  Future<SudoCardTransactionsModel> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await ApiServices.sudoCardTransactionApi(controller.cardId.value)
        .then((value) {
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
