import "package:stripcard/base/api/services/cardyfie_api_services.dart";
import "package:stripcard/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/card_details_model_cardyfie.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_details_controller.dart";
import "package:stripcard/base/api/services/strowallet_api_services.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";

class CardyfieDetailsController extends GetxController {
  RxBool isShowSensitive = false.obs;
  RxString cardPlan = "".obs;
  RxString cardCVC = "".obs;
  final cardyfieController = Get.put(VirtualCardyfieCardController());

  @override
  void onInit() {
    getCardDetailsData();
    super.onInit();
  }

  ///>>>>>>>>>> get details data
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Card Details Method
  late CardDetailsModelCardyfie _cardDetailsModelCardyfie;
  CardDetailsModelCardyfie get cardDetailsModelCardyfie =>
      _cardDetailsModelCardyfie;

  Future<CardDetailsModelCardyfie> getCardDetailsData() async {
    _isLoading.value = true;
    update();

    await CardyfieApiServices.cardyfieCardDetailsApi(
          cardyfieController.cardyfieCardUIId.value,
        )
        .then((value) {
          _cardDetailsModelCardyfie = value!;

          // if (_cardDetailsModelCardyfie.data.myCard.status == true) {
          //   isSelected.value = true;
          // } else {
          //   isSelected.value = false;
          // }

          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
          update();
        });

    _isLoading.value = false;
    update();
    return _cardDetailsModelCardyfie;
  }

  RxBool isSelected = false.obs; // For UI switch
  RxString isStatus = "ENABLED".obs; // Default status
  RxBool _isCardStatusLoading = false.obs;

  bool get isCardStatusLoading => _isCardStatusLoading.value;

  late CommonSuccessModel _cardActiveModel;
  CommonSuccessModel get cardActiveModel => _cardActiveModel;

  // ✅ Toggle logic
  void cardToggle() {
    // Toggle the UI switch value
    isSelected.value = !isSelected.value;

    // Update the status string
    if (isSelected.value) {
      isStatus.value = "FREEZE";
    } else {
      isStatus.value = "ENABLED";
    }

    // Call the API
    cardFreezeUnFreezeApi();
  }

  Future<CommonSuccessModel> cardFreezeUnFreezeApi() async {
    _isCardStatusLoading.value = true;

    Map<String, dynamic> inputBody = {
      'card_id': cardyfieController.cardyfieCardUIId.value,
      'status': isStatus.value,
    };
    try {
      final value = await CardyfieApiServices.cardyfieFreezeApi(
        body: inputBody,
      );
      _cardActiveModel = value!;
      await getCardDetailsData(); // refresh data
    } catch (e) {
      log.e(e);
    } finally {
      _isCardStatusLoading.value = false;
    }

    return _cardActiveModel;
  }
}
