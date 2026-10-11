import 'dart:io';

import 'package:flutter/services.dart';

import "package:stripcard/base/api/model/virtual_card/sudo_models/sudo_card_details_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_sudo/controller/sudo_my_card_controller.dart";

class SudoCardDetailsController extends GetxController {
  RxBool isSelected = false.obs;
  RxBool isShowSensitive = false.obs;
  RxInt activeIndicatorIndex = 0.obs;
  final virtualController = Get.put(VirtualSudoCardController());
   RxBool isRevealedDetails = false.obs;

 
  @override
  void onInit() {
    getCardDetailsData();
    super.onInit();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isCardStatusLoading = false.obs;
  bool get isCardStatusLoading => _isCardStatusLoading.value;
  // Card Details Method
  late SudoCardDetailsModel _cardDetailsModel;
  SudoCardDetailsModel get cardDetailsModel => _cardDetailsModel;

  Future<SudoCardDetailsModel> getCardDetailsData() async {
    _isLoading.value = true;
    update();

    await ApiServices.sudoCardDetailsApi(id: virtualController.cardId.value)
        .then((value) {
      _cardDetailsModel = value!;

      if (_cardDetailsModel.data.cardDetails.status == true) {
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
      'card_id': virtualController.cardId.value,
    };
    await ApiServices.sudoCardBlockApi(body: inputBody).then((value) {
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
      'card_id': virtualController.cardId.value,
    };
    await ApiServices.sudoCardUnBlockApi(body: inputBody).then((value) {
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
    if (_cardDetailsModel.data.cardDetails.status == true) {
      _cardBlockApi();
    } else {
      _cardUnBlockApi();
    }
  }

  get cardToggle => _cardToggle();

//started send data

  bool isLoadings = false;
  bool isRevealed = false;
  sendData(dynamic payload) async {
    isLoadings = true;

    final result = await revealData(
      payload,
      CollectShowConstants.revealPath,
    );
    var resultData = new Map<String, dynamic>.from(result);
    final resultStatus = resultData[EventPayloadNames.status];
    if (resultStatus == EventPayloadNames.success) {
      isLoadings = false;
      isRevealed = true;

      CustomSnackBar.success("success");
    } else if (resultStatus == EventPayloadNames.failed) {
      isLoadings = false;

      CustomSnackBar.error("reval data failed");
    }
  }
}

class CollectShowConstants {
  static const vaultID = 'vault_id';
  static const environment = 'sandbox';
  static const revealPath = 'post';
  static const microBlinkiOSLicenceKey = 'ios_licence_key';
  static const microBlinkAndroidLicenceKey = 'android_licence_key';

  static bool hasMicroBlinkLicenceKey() {
    if (Platform.isIOS) {
      return microBlinkiOSLicenceKey != 'ios_licence_key';
    } else if (Platform.isAndroid) {
      return microBlinkAndroidLicenceKey != 'android_licence_key';
    } else {
      throw Exception('Platform is not supported!');
    }
  }
}

class EventPayloadNames {
  static const String status = 'STATUS';
  static const String success = 'SUCCESS';
  static const String failed = 'FAILED';
  static const String data = 'DATA';
  static const String stateDescription = 'STATE_DESCRIPTION';
  static const String microBlinkErrorCode = 'MicroBlinkErrorCode';
}

///>>> late

late final MethodChannel channel;
Future<Map<dynamic, dynamic>> revealData(dynamic payload, String path) async {
  return await channel
      .invokeMethod("revealCard", {'payload': payload, 'path': path});
}
