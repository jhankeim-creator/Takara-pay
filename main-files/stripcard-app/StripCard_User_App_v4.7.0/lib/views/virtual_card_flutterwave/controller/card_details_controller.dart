import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/card_deatils_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_flutterwave/controller/flutterwave_card_controller.dart";

class CardDetailsController extends GetxController {
  RxBool isSelected = false.obs;

  final myCardController = Get.put(FlutterWaveCardController());
  @override
  void onInit() {
    getCardDetailsData();
    super.onInit();
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isCardStatusLoading = false.obs;
  bool get isCardStatusLoading => _isCardStatusLoading.value;
  // Card Details Method
  late CardDetailsModel _cardDetailsModel;
  CardDetailsModel get cardDetailsModel => _cardDetailsModel;

  Future<CardDetailsModel> getCardDetailsData() async {
    _isLoading.value = true;
    update();

    await ApiServices.cardDetailsApi(myCardController.cardId.value)
        .then((value) {
      _cardDetailsModel = value!;

      if (_cardDetailsModel.data.myCards.status == 0) {
        isSelected.value = true;
      } else {
        isSelected.value = false;
      }

      print(isSelected.value);
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
      update();
    });

    _isLoading.value = false;
    update();
    return _cardDetailsModel;
  }

  late CommonSuccessModel _cardBlockModel;
  CommonSuccessModel get cardBlockModel => _cardBlockModel;

  Future<CommonSuccessModel> _cardBlockApi() async {
    _isCardStatusLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'card_id': myCardController.cardId.value,
    };
    await ApiServices.cardBlockApi(body: inputBody).then((value) {
      _cardBlockModel = value!;
      update();
      debugPrint('Card Blocked');
      getCardDetailsData();
    }).catchError((onError) {
      log.e(onError);
      _isCardStatusLoading.value = false;
      update();
    });

    _isCardStatusLoading.value = false;
    update();
    return _cardBlockModel;
  }

  late CommonSuccessModel _cardUnBlockModel;
  CommonSuccessModel get cardUnBlockModel => _cardUnBlockModel;

  Future<CommonSuccessModel> _cardUnBlockApi() async {
    _isCardStatusLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'card_id': myCardController.cardId.value,
    };
    await ApiServices.cardUnblockApi(body: inputBody).then((value) {
      _cardUnBlockModel = value!;
      update();
      debugPrint('Card Unblocked');
      getCardDetailsData();
    }).catchError((onError) {
      log.e(onError);
      _isCardStatusLoading.value = false;
      update();
    });

    _isCardStatusLoading.value = false;
    update();
    return _cardUnBlockModel;
  }

  _cardToggle() {
    if (_cardDetailsModel.data.myCards.status == 0) {
      _cardUnBlockApi();
    } else {
      _cardBlockApi();
    }
  }

  get cardToggle => _cardToggle();
}
