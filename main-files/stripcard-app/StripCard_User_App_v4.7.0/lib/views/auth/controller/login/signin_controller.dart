import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/model/auth/login_model.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/routes/routes.dart";

class SignInController extends GetxController {
  final emailAddressController = TextEditingController();
  final forgetEmailAddressController = TextEditingController();
  final otpPhoneController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController(); 
  
  // @override
  // void onInit() {
  //   emailAddressController.text = "user@appdevs.net";
  //   passwordController.text = "appdevs";
  //   super.onInit();
  // }

  @override
  void dispose() {
    emailAddressController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    forgetEmailAddressController.dispose();
    otpPhoneController.dispose();
    super.dispose();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  final _isForgetPasswordLoading = false.obs;

  bool get isForgetPasswordLoading => _isForgetPasswordLoading.value;

  late LoginModel _loginModel;

  LoginModel get loginModel => _loginModel;

  // Login process function
  Future<LoginModel> loginProcess() async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'email': emailAddressController.text,
      'password': passwordController.text,
    };
    // calling login api from api service
    await ApiServices.loginApi(body: inputBody)
        .then((value) {
          _loginModel = value!;

          if (_loginModel.data.user.emailVerified == 0) {
            _goToEmailVerification(_loginModel);
          } else if (_loginModel.data.user.twoFactorStatus == 1 &&
              _loginModel.data.user.twoFactorVerified == 0) {
            Get.toNamed(Routes.otp2FaScreen);
          } else {
            _goToSavedUser(_loginModel);
          }
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _loginModel;
  }

  // Forget Password Email Process
  late CommonSuccessModel _forgetPasswordModel;

  CommonSuccessModel get forgetPasswordModel => _forgetPasswordModel;

  Future<CommonSuccessModel> forgetPasswordEmailProcess() async {
    _isForgetPasswordLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'email': forgetEmailAddressController.text,
    };
    await ApiServices.forgetPasswordApi(body: inputBody)
        .then((value) {
          _forgetPasswordModel = value!;
          Get.toNamed(Routes.resetOtpScreen);
          update();
          emailAddressController.clear();
        })
        .catchError((onError) {
          log.e(onError);
          _isForgetPasswordLoading.value = false;
        });

    _isForgetPasswordLoading.value = false;
    update();
    return _forgetPasswordModel;
  }

  void onPressedSignUP() {
    Get.toNamed(Routes.registrationScreen);
  }

  void _goToSavedUser(LoginModel loginModel) {
    final token = loginModel.data.token.toString();
    LocalStorage.saveToken(token: token);
    LocalStorage.isLoginSuccess(isLoggedIn: true);
    LocalStorage.saveId(id: loginModel.data.user.id.toString());
    // Remember this session for biometric re-entry ("Sign in with fingerprint").
    LocalStorage.enableBiometric(
      token: token,
      email: emailAddressController.text,
      password: passwordController.text,
    );
    LocalStorage.isLoggedIn();
    update();
    _goToDashboardScreen();
  }

  _goToDashboardScreen() {
    Get.offAndToNamed(Routes.bottomNavBarScreen);
  }

  void _goToEmailVerification(LoginModel loginModel) {
    LocalStorage.saveToken(token: loginModel.data.token.toString());
    LocalStorage.saveEmail(email: emailAddressController.text);
    Get.toNamed(Routes.emailOtpScreen);
  }
}
