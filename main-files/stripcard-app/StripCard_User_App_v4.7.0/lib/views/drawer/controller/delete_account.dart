import 'package:get/get.dart';

import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/routes/routes.dart";

class SettingController extends GetxController {
  RxBool fingerprint = false.obs;
  RxBool facelock = false.obs;

  RxString selectLanguage = 'English'.obs;

  List<String> languageList = ['English', 'Bangla'];

  void onTapChangePassword() {
    Get.toNamed(Routes.changePasswordScreen);
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  //! delete account Process
  late CommonSuccessModel _deleteAccountModel;

  CommonSuccessModel get deleteAccountModel => _deleteAccountModel;

  Future<CommonSuccessModel> deleteAccountProcess() async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {};
    // delete account api from api service
    await ApiServices.deleteAccountApi(body: inputBody).then((value) {
      _deleteAccountModel = value!;

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _deleteAccountModel;
  }
}
