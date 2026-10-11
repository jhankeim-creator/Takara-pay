import "package:TAKARA PAY/base/api/model/virtual_card/strowallet_models/strowallet_webhook_model.dart";
import "package:TAKARA PAY/base/api/services/strowallet_api_services.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";

class StrowalletWebhookController extends GetxController {
  final controller = Get.put(VirtualStrowalletCardController());
  @override
  void onInit() {
    getCardTransactionHistory();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late WebhookLogModel _webhookLogModel;
  WebhookLogModel get webhookLogModel =>
      _webhookLogModel;

  Future<WebhookLogModel> getCardTransactionHistory() async {
    _isLoading.value = true;
    update();

    await StrowalletApiServices.strowalletWebhookLogsApi(
            controller.strowalletCardId.value)
        .then((value) {
      _webhookLogModel = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _webhookLogModel;
  }
}
