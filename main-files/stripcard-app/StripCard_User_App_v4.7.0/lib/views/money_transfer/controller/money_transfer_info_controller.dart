import "package:TAKARA PAY/base/api/model/transfer_money/transfer_money_info_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";

class MoneyTransferInfoController extends GetxController {
  @override
  void onInit() {
    getTransferMoneyData();
    super.onInit();
  }

  RxDouble balance = 0.00.obs;
  RxString currency = "".obs;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late TransferMoneyInfoModel _transferMoneyInfoModel;
  TransferMoneyInfoModel get transferMoneyInfoModel => _transferMoneyInfoModel;

  Future<TransferMoneyInfoModel> getTransferMoneyData() async {
    _isLoading.value = true;
    update();

    await ApiServices.transferMoneyInfoApi()
        .then((value) {
          _transferMoneyInfoModel = value!;
          balance.value = _transferMoneyInfoModel.data.userWallet.balance;
          currency.value = _transferMoneyInfoModel.data.userWallet.currency;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _transferMoneyInfoModel;
  }
}
