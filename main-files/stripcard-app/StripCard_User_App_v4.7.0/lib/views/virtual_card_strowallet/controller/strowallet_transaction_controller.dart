import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_transaction_model.dart";
import "package:stripcard/base/api/services/strowallet_api_services.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";

class StrowalletTransactionController extends GetxController {
  final controller = Get.put(VirtualStrowalletCardController());

  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late StrowalletCardTransactionModel _strowalletCardTransactionsModel;
  StrowalletCardTransactionModel get strowalletCardTransactionsModel =>
      _strowalletCardTransactionsModel;

  Future<StrowalletCardTransactionModel> getCardTransactionHistory() async {

    _isLoading.value = true;
    update();

    await StrowalletApiServices.strowalletCardTransactionApi(
            controller.strowalletCardId.value)
        .then((value) {
      _strowalletCardTransactionsModel = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _strowalletCardTransactionsModel;
  }
}
