import 'package:get/get.dart';
import "package:stripcard/base/api/model/others/transaction_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/logger.dart";

final log = logger(TransactionController);

class TransactionController extends GetxController {
    @override
  void onInit() {
    super.onInit();
    getTransactionData();
  }
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late TransationLogModel _transactioData;
  TransationLogModel get transactioData => _transactioData;



  // --------------------------- Api function ----------------------------------
  Future<TransationLogModel> getTransactionData() async {
    _isLoading.value = true;
    update();

    await ApiServices.getTransactionLogAPi().then((value) {
      _transactioData = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _transactioData;
  }
}
