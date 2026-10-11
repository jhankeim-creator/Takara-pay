import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/api/model/two_fa/two_fa_model.dart";
import "package:TAKARA PAY/routes/routes.dart";

class TwoFaController extends GetxController {

  final numberController = TextEditingController();

  // Authenticator code the user types on this screen. The latest API
  // requires proof-of-possession (the current 6-digit TOTP code) to
  // enable OR disable 2FA — it no longer accepts a bare on/off flag.
  final codeController = TextEditingController();

  RxString qrCode = ''.obs;
  RxString secret = ''.obs;
  RxString alert = ''.obs;
  RxInt status = 0.obs;

  @override
  void onInit() {
    getBasicData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late TwoFaInfoModel _twoFaInfoModelData;

  TwoFaInfoModel get twoFaInfoModelData => _twoFaInfoModelData;

  Future<TwoFaInfoModel> getBasicData() async {
    _isLoading.value = true;

    update();

    // calling  from api service
    await ApiServices.getTwoFAInfoAPi().then((value) {
      _twoFaInfoModelData = value!;
      _setData(_twoFaInfoModelData);
      _isLoading.value = false;
      update();
    }).catchError(
      (onError) {
        log.e(onError);
      },
    );
    update();
    return _twoFaInfoModelData;
  }

  void gotoOtp() {
    Get.toNamed(Routes.otp2FaScreen);
  }

  /// >> set loading process & Two Fa Submit Model
  final _isSubmitLoading = false.obs;
  // Nullable — a wrong/expired authenticator code is a normal, expected
  // failure now that `code` is required input, and the old `late` field +
  // unguarded `value!` here threw a LateInitializationError on every wrong
  // code (caught nowhere, since the screen doesn't await this call).
  CommonSuccessModel? _twoFaSubmitModel;

  /// >> get loading process & Two Fa Submit Model
  bool get isSubmitLoading => _isSubmitLoading.value;
  CommonSuccessModel? get twoFaSubmitModel => _twoFaSubmitModel;

  ///* Two fa submit api process
  ///
  /// The backend now toggles the account's 2FA status server-side and
  /// requires the user's current authenticator `code` to prove they control
  /// the device — a bare `status` flag is no longer accepted (returns a
  /// validation error otherwise).
  Future<CommonSuccessModel?> twoFaSubmitApiProcess() async {
    _isSubmitLoading.value = true;
    update();

    Map<String, String> inputBody = {
      'code': codeController.text.trim(),
    };

    await ApiServices.twoFaSubmitApiProcess(
      body: inputBody,
    ).then((value) {
      if (value == null) return;
      _twoFaSubmitModel = value;
      Get.offAllNamed(Routes.bottomNavBarScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isSubmitLoading.value = false;
    update();
    return _twoFaSubmitModel;
  }

  _setData(TwoFaInfoModel twoFaInfoModel) {
    qrCode.value = twoFaInfoModel.data.qrCode;
    secret.value = twoFaInfoModel.data.qrSecrete;
    alert.value = twoFaInfoModel.data.alert;
    status.value = twoFaInfoModel.data.qrStatus;
  }

  @override
  void onClose() {
    numberController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
