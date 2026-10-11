import "package:stripcard/base/api/services/cardyfie_api_services.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";

import "package:stripcard/base/api/model/virtual_card/cardyfie_model/card_transaction_model_cardyfie.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_transaction_model.dart";
import "package:stripcard/base/api/services/strowallet_api_services.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

class CardyfieTransactionLogController extends GetxController {
  final controller = Get.put(VirtualCardyfieCardController());

  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late CardTransactionModelCardyfie _cardTransactionModelCardyfie;
  CardTransactionModelCardyfie get cardTransactionModelCardyfie =>
      _cardTransactionModelCardyfie;

  Future<CardTransactionModelCardyfie> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await CardyfieApiServices.cardyfieCardTransactionApi(
          controller.cardyfieCardUIId.value,
        )
        .then((value) {
          _cardTransactionModelCardyfie = value!;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _cardTransactionModelCardyfie;
  }
}
