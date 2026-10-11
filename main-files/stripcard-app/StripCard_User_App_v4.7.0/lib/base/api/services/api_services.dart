import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_bkash_model.dart";
import "package:TAKARA PAY/base/api/model/remaining_balance_model/remaining_balance_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/authorize_confirm_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/authorize_submit_model.dart";
import "package:TAKARA PAY/base/api/model/two_fa/two_fa_model.dart";
import "package:TAKARA PAY/base/api/model/transfer_money/transfer_money_info_model.dart";
import "package:TAKARA PAY/base/api/model/transfer_money/transfer_exist_model.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/base/api/model/add_money/add_money_info_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_flutterwave.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_paypal_getway.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_razorpay_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_ssclcommerz_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_stripe_getway_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/common_payment_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/manual_payment_getway_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/tatum/tatum_insert_model.dart";
import "package:TAKARA PAY/base/api/model/auth/login_model.dart";
import "package:TAKARA PAY/base/api/model/auth/sign_up_model.dart";
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/dashboard/dashboard_model.dart";
import "package:TAKARA PAY/base/api/model/kyc/kyc_info_model.dart";
import "package:TAKARA PAY/base/api/model/onboard/app_settings_model.dart";
import "package:TAKARA PAY/base/api/model/others/transaction_model.dart";
import "package:TAKARA PAY/base/api/model/others/usefull_link_model.dart";
import "package:TAKARA PAY/base/api/model/profile/profile_info_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/card_charges_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/card_deatils_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/card_transaction_history_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/my_card_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/stripe_models/stripe_card_details_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/stripe_models/stripe_card_info_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/stripe_models/stripe_card_sensitive_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/stripe_models/stripe_transaction_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_card_details_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_card_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_charges_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_transaction_history_model.dart";
import "package:TAKARA PAY/base/api/model/withdraw/dynamic_input_withdraw_model.dart";
import "package:TAKARA PAY/base/api/model/withdraw/withdraw_info_model.dart";
import "package:TAKARA PAY/base/api/method/api_method.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/base/utils/logger.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";

final log = logger(ApiServices);

class ApiServices {
  static var client = http.Client();

  // Generic API service method
  static Future<T?> apiService<T>(
    T Function(Map<String, dynamic>) fromJson,
    String apiEndpoint, {
    Map<String, dynamic>? body,
    String method = 'GET',
    int statusCode = 200,
    bool showResult = false,
    bool isBasic = false,
    bool showSuccessMessage = false,
    String tostTitle = 'Success',
  }) async {
    try {
      Map<String, dynamic>? mapResponse;

      if (method == 'POST') {
        mapResponse = await ApiMethod(
          isBasic: isBasic,
        ).post(apiEndpoint, body ?? {}, code: statusCode);
      } else if (method == 'GET') {
        mapResponse = await ApiMethod(
          isBasic: isBasic,
        ).get(apiEndpoint, showResult: showResult);
      }

      if (mapResponse != null) {
        return _handleResponse<T>(
          mapResponse,
          fromJson,
          showSuccessMessage,
          tostTitle,
        );
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from ApiService ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went wrong!');
    }
    return null;
  }

  // Method for multipart file uploads
  static Future<T?> multipartApiService<T>(
    T Function(Map<String, dynamic>) fromJson,
    String apiEndpoint,
    Map<String, String> body,
    List<String> fieldList,
    List<String> pathList, {
    int statusCode = 200,
    bool isBasic = false,
    bool showSuccessMessage = false,
    String tostTitle = 'Success',
  }) async {
    try {
      Map<String, dynamic>? mapResponse = await ApiMethod(isBasic: isBasic)
          .multipartMultiFile(
            apiEndpoint,
            body,
            fieldList: fieldList,
            pathList: pathList,
          );

      if (mapResponse != null) {
        return _handleResponse<T>(
          mapResponse,
          fromJson,
          showSuccessMessage,
          tostTitle,
        );
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from multipartApiService ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went wrong!');
    }
    return null;
  }

  // Helper method to handle responses
  static T? _handleResponse<T>(
    Map<String, dynamic> mapResponse,
    T Function(Map<String, dynamic>) fromJson,
    bool showSuccessMessage,
    String tostTitle,
  ) {
    T result = fromJson(mapResponse);

    if (showSuccessMessage) {
      var messages = CommonSuccessModel.fromJson(mapResponse);
      CustomSnackBar.success(messages.message.success.first.toString());
    }

    return result;
  }

  // App Settings Api
  static Future<AppSettingsModel?> appSettingsApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: true,
      ).get(ApiEndpoint.appSettingsURL, showResult: true);
      if (mapResponse != null) {
        AppSettingsModel appSettingsModel = AppSettingsModel.fromJson(
          mapResponse,
        );

        return appSettingsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from App Settings Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in App Settings Model');
      return null;
    }
    return null;
  }

  //Login Api method
  static Future<LoginModel?> loginApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        "${ApiEndpoint.loginURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        LoginModel loginModel = LoginModel.fromJson(mapResponse);
        //CustomSnackBar.success(loginModel.message.success.first.toString());
        return loginModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from login api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in LoginModel');
      return null;
    }
    return null;
  }

  //forget password insert Api method
  static Future<CommonSuccessModel?> forgetPasswordApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        "${ApiEndpoint.forgetPasswordURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel forgetPasswordModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        //CustomSnackBar.success(forgetPasswordModel.message.success.first.toString());
        return forgetPasswordModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from login Forget Password Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Forget Password Api');
      return null;
    }
    return null;
  }

  //forget password verify email Api method
  static Future<CommonSuccessModel?> forgetPasswordVerifyEmailApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        "${ApiEndpoint.forgetPasswordVerifyURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel forgetPasswordVerifyEmailModel =
            CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(
          forgetPasswordVerifyEmailModel.message.success.first.toString(),
        );
        return forgetPasswordVerifyEmailModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from Forget Password Email Verify Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in Forget Password Email Verify Api',
      );
      return null;
    }
    return null;
  }

  // password  reset code
  static Future<CommonSuccessModel?> passwordResetCodeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: true,
      ).post(ApiEndpoint.forgetPasswordURL, body, showResult: true);
      if (mapResponse != null) {
        CommonSuccessModel forgetPasswordVerifyEmailModel =
            CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     forgetPasswordVerifyEmailModel.message.success.first.toString());
        return forgetPasswordVerifyEmailModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Password Reset Code Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Password Reset Code Api');
      return null;
    }
    return null;
  }

  // change password Api method
  static Future<CommonSuccessModel?> changePasswordApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        "${ApiEndpoint.resetPasswordURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel changePasswordModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     changePasswordModel.message.success.first.toString());
        return changePasswordModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from change Password Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in change Password Api');
      return null;
    }
    return null;
  }

  //Register Api method
  static Future<SignUpModel?> registerApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        "${ApiEndpoint.registerURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        SignUpModel registerModel = SignUpModel.fromJson(mapResponse);
        // CustomSnackBar.success(registerModel.message.success.first.toString());
        return registerModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from  Register Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Register Api');
      return null;
    }
    return null;
  }

  //verify email Api method
  static Future<CommonSuccessModel?> verifyMailCodeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.emailVerifyURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel mailVerifyCodeModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     mailVerifyCodeModel.message.success.first.toString());
        return mailVerifyCodeModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from verify Mail Code Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in verify Mail Code Api');
      return null;
    }
    return null;
  }

  //resend email Api method
  static Future<CommonSuccessModel?> resendVerificationCodeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sendCodeURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel mailCodeModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(mailCodeModel.message.success.first.toString());
        return mailCodeModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from resend Verification Code Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in resend Verification Code Api',
      );
      return null;
    }
    return null;
  }

  //profile Api method
  static Future<ProfileModel?> userProfileApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.profileInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        ProfileModel userProfileModel = ProfileModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     userProfileModel.message.success.first.toString());
        return userProfileModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from User Profile Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in User Profile Api');
      return null;
    }
    return null;
  }

  //update password Api method
  static Future<CommonSuccessModel?> updatePasswordApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.passwordUpdateURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel changePasswordModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(
          changePasswordModel.message.success.first.toString(),
        );
        return changePasswordModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from change Password Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in change Password Api');
      return null;
    }
    return null;
  }

  //dashboard Api method
  static Future<DashBoardModel?> dashboardApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.dashboardURL}?lang=${languageSettingsController.selectedLanguage.value}",
        duration: 30,
        showResult: true,
      );
      if (mapResponse != null) {
        DashBoardModel dashboardModel = DashBoardModel.fromJson(mapResponse);
        // CustomSnackBar.success(dashboardModel.message.success.first.toString());
        return dashboardModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Dashboard Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Dashboard Api');
      return null;
    }
    return null;
  }

  //My Card Api method
  static Future<FlutterMyCardModel?> myCardApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.myCardURL}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        FlutterMyCardModel myCardModel = FlutterMyCardModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(myCardModel.message.success.first.toString());
        return myCardModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from my Card Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in my Card Api');
      return null;
    }
    return null;
  }

  //!My Card Details Api method
  //todo
  static Future<CardDetailsModel?> cardDetailsApi(String cardId) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get("${ApiEndpoint.cardDetailsURL}${cardId}", showResult: true);
      if (mapResponse != null) {
        CardDetailsModel cardDetailsModel = CardDetailsModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     cardDetailsModel.message.success.first.toString());
        return cardDetailsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from my Card Details Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in my Card Details Api');
      return null;
    }
    return null;
  }

  // card transaction api
  //todo
  static Future<CardTransactionsModel?> cardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get("${ApiEndpoint.cardTransactionsURL}${cardId}", showResult: true);
      if (mapResponse != null) {
        CardTransactionsModel cardTransactionModel =
            CardTransactionsModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     cardTransactionModel.message.success.first.toString());
        return cardTransactionModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from my Card Transaction Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in my Card Transaction Api');
      return null;
    }
    return null;
  }

  // card charges info api
  static Future<CardChargesModel?> cardChargesApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.cardChargesURL}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        CardChargesModel cardChargesModel = CardChargesModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     cardChargesModel.message.success.first.toString());
        return cardChargesModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Card Charges Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Card Charges Model');
      return null;
    }
    return null;
  }

  //buy card Api method
  static Future<CommonSuccessModel?> createCardApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.buyCardURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel createCardModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     createCardModel.message.success.first.toString());
        return createCardModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from create card api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in create Card Model');
      return null;
    }
    return null;
  }

  //Card Block Api Method
  static Future<CommonSuccessModel?> cardBlockApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.cardBlockURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(cardBlockModel.message.success.first.toString());
        return cardBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Card Block api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Card Block Model');
      return null;
    }
    return null;
  }

  //Card unBlock Api Method
  static Future<CommonSuccessModel?> cardUnblockApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.cardUnblockURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnblockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(
          cardUnblockModel.message.success.first.toString(),
        );
        return cardUnblockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Card Unblock api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Card UnBlock Model');
      return null;
    }
    return null;
  }

  //Card Fund Api Method
  static Future<CommonSuccessModel?> cardFundApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.cardFundURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardFundModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(cardFundModel.message.success.first.toString());
        return cardFundModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Card Fund api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Card Fund Model');
      return null;
    }
    return null;
  }

  //Card withdraw Api Method
  static Future<CommonSuccessModel?> cardWithdrawApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.withdrawFromCardURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardWithdrawModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     cardWithdrawModel.message.success.first.toString());
        return cardWithdrawModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Card Withdraw api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Card Withdraw Model');
      return null;
    }
    return null;
  }

  // add money manual Api
  static Future<ManualPaymentGatewayModel?> manualPaymentApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        ManualPaymentGatewayModel manualPaymentGetGatewayModel =
            ManualPaymentGatewayModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     manualPaymentGetGatewayModel.message.success.first.toString());
        return manualPaymentGetGatewayModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Manual Payment Gateway api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        'Something went Wrong! in ManualPaymentGetGatewayModel',
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Paypal Gateway
  static Future<AutomaticPaymentPaypalGatewayModel?>
  automaticPaymentPaypalGatewayApi({required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentPaypalGatewayModel automaticPaymentPaypalGatewayModel =
            AutomaticPaymentPaypalGatewayModel.fromJson(mapResponse);
        // CustomSnackBar.success(automaticPaymentPaypalGatewayModel
        //     .message.success.first
        //     .toString());
        return automaticPaymentPaypalGatewayModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment Paypal Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in automaticPaymentPaypalGatewayModel',
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Stripe Gateway
  static Future<AutomaticPaymentStripeGatewayModel?>
  automaticPaymentStripeGatewayApi({required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentStripeGatewayModel automaticPaymentStripeGatewayModel =
            AutomaticPaymentStripeGatewayModel.fromJson(mapResponse);
        // CustomSnackBar.success(automaticPaymentStripeGatewayModel
        //     .message.success.first
        //     .toString());
        return automaticPaymentStripeGatewayModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment Stripe Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in automaticPaymentStripeGatewayModel',
      );
      return null;
    }
    return null;
  }

  // Stripe Confirm Api
  static Future<CommonSuccessModel?> stripeConfirmApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.StripeConfirmedURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel stripeConfirmModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     stripeConfirmModel.message.success.first.toString());
        return stripeConfirmModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Stripe Confirm Api  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in Stripe Confirm Api ');
      return null;
    }
    return null;
  }

  //add Money Manual Confirmed Api
  static Future<CommonSuccessModel?> addMoneyManualConfirmedApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
        "${ApiEndpoint.addMoneyManualConfirmedURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        CommonSuccessModel addMoneyManualConfirmedModel =
            CommonSuccessModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     addMoneyManualConfirmedModel.message.success.first.toString());
        return addMoneyManualConfirmedModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from Add Money Manual Confirmed api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in Add Money Manual Confirmed Model',
      );
      return null;
    }
    return null;
  }

  // Add Money Info Api
  static Future<AddMoneyInfoModel?> addMoneyInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.addMoneyInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        AddMoneyInfoModel addMoneyInfoModel = AddMoneyInfoModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     addMoneyInfoModel.message.success.first.toString());
        return addMoneyInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Add Money Info Api  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in addMoneyInfoModel');
      return null;
    }
    return null;
  }

  //  update profile Without Image Api method
  static Future<CommonSuccessModel?> updateProfileWithoutImageApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.profileUpdateURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel updateProfileModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(
          updateProfileModel.message.success.first.toString(),
        );
        return updateProfileModel;
      }
    } catch (e) {
      log.e('err from update profile api service ==> $e');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // update profile With Image api
  static Future<CommonSuccessModel?> updateProfileWithImageApi({
    required Map<String, String> body,
    required String filepath,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipart(
        "${ApiEndpoint.profileUpdateURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        filepath,
        'image',
        code: 200,
      );

      if (mapResponse != null) {
        CommonSuccessModel profileUpdateModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(
          profileUpdateModel.message.success.first.toString(),
        );
        return profileUpdateModel;
      }
    } catch (e) {
      log.e('err from profile update api service ==> $e');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //  log Out
  static Future<CommonSuccessModel?> logOutApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.logOutURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel updateProfileModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(
          updateProfileModel.message.success.first.toString(),
        );
        return updateProfileModel;
      }
    } catch (e) {
      log.e('err from log Out api service ==> $e');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //useFullLinkApi
  static Future<UseFullLinkModel?> useFullLinkApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.usefulLinks}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        UseFullLinkModel useFullLinkModel = UseFullLinkModel.fromJson(
          mapResponse,
        );

        return useFullLinkModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from use Full Link Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in use Full Link Model');
      return null;
    }
    return null;
  }

  //kyc Additional field method
  static Future<KycInfoModel?> kycInputFieldsApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.kycInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        duration: 15,
        showResult: true,
      );
      if (mapResponse != null) {
        KycInfoModel kycInfoModel = KycInfoModel.fromJson(mapResponse);
        return kycInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from kyc additional field api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //submit manual payment gateway Api method
  static Future<CommonSuccessModel?> submitKycApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).multipartMultiFile(
        "${ApiEndpoint.submitKycURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        // duration: 15,
        showResult: true,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        CommonSuccessModel commonSuccessModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     automaticPaymentGatewayModel.message.success.first.toString());
        return commonSuccessModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from kyc submit api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //
  // ---------------------------------------------------------------------------
  //                              Virtual Card Stripe
  // ---------------------------------------------------------------------------
  //

  //stripe card info api
  static Future<StripeCardInfoModel?> stripeCardInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.stripeCardInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        StripeCardInfoModel cardInfoModel = StripeCardInfoModel.fromJson(
          mapResponse,
        );

        return cardInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from stripe card info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in stripe card info Api');
      return null;
    }
    return null;
  }

  // stripe card details api

  //todo remain
  static Future<StripeCardDetailsModel?> stripeCardDetailsApi(String id) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.stripeCardDetailsURL + id,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        StripeCardDetailsModel cardDetailsModel =
            StripeCardDetailsModel.fromJson(mapResponse);

        return cardDetailsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from stripe card details api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        'Something went Wrong! in stripe card details info Api',
      );
      return null;
    }
    return null;
  }

  //stripe card transaction method
  //todo remain
  static Future<StripeCardTransactionModel?> stripeCardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.stripeCardTransactionURL}${cardId}",
        showResult: true,
      );
      if (mapResponse != null) {
        StripeCardTransactionModel cardTransactionModel =
            StripeCardTransactionModel.fromJson(mapResponse);
        // CustomSnackBar.error(
        //     cardTransactionModel.message.success.first.toString());
        return cardTransactionModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from my stripe Card Transaction Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // stripe card sensitive api
  static Future<StripeSensitiveModel?> stripeSensitiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.stripeSensitiveURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        StripeSensitiveModel cardBlockModel = StripeSensitiveModel.fromJson(
          mapResponse,
        );

        return cardBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from stripe sensitive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in stripe sensitive Api');
      return null;
    }
    return null;
  }

  //stripe card inactive api
  static Future<CommonSuccessModel?> stripeInactiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.stripeInactiveURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return cardUnBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from inactive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! inactive Api');
      return null;
    }
    return null;
  }

  // stripe card active api
  static Future<CommonSuccessModel?> stripeActiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.stripeActiveURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return cardUnBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from stripe card active Api api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        'Something went Wrong! in stripe card active  Api info Api',
      );
      return null;
    }
    return null;
  }

  //stripe card buy  Api Method
  static Future<CommonSuccessModel?> stripeBuyCardApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.stripeBuyCardURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnblockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.error(cardUnblockModel.message.success.first.toString());
        return cardUnblockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from stripe card buy api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in stripe card buy Model');
      return null;
    }
    return null;
  }

  //
  // ---------------------------------------------------------------------------
  //                              Virtual Card Sudo
  // ---------------------------------------------------------------------------
  //

  // card info api
  static Future<SudoMyCardModel?> sudoCardInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.sudoCardInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        SudoMyCardModel cardInfoModel = SudoMyCardModel.fromJson(mapResponse);

        return cardInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from sudo card info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in sudo card info Api');
      return null;
    }
    return null;
  }

  // card details api
  //todo remain
  static Future<SudoCardDetailsModel?> sudoCardDetailsApi({
    required String id,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.sudoCardDetailsURL + id, code: 200, showResult: false);
      if (mapResponse != null) {
        SudoCardDetailsModel cardDetailsModel = SudoCardDetailsModel.fromJson(
          mapResponse,
        );

        return cardDetailsModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from card details api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in card details info Api');
      return null;
    }
    return null;
  }

  // card block api

  static Future<CommonSuccessModel?> sudoCardBlockApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sudoCardBlockURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return cardBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from card block api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in add money info Api');
      return null;
    }
    return null;
  }

  // card unblock api
  static Future<CommonSuccessModel?> sudoCardUnBlockApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sudoCardUnBlockURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return cardUnBlockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from card unblock api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in add money info Api');
      return null;
    }
    return null;
  }

  //todo remain
  static Future<SudoCardTransactionsModel?> sudoCardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.sudoCardTransactionsURL}${cardId}",
        showResult: true,
      );
      if (mapResponse != null) {
        SudoCardTransactionsModel cardTransactionModel =
            SudoCardTransactionsModel.fromJson(mapResponse);
        // CustomSnackBar.success(
        //     cardTransactionModel.message.success.first.toString());
        return cardTransactionModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from my sudo Card Transaction Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in my sudo Card Transaction Api',
      );
      return null;
    }
    return null;
  }

  // card make or remove default api
  static Future<CommonSuccessModel?> sudoCardMakeOrRemoveDefaultApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sudoCardMakeOrRemoveDefaultFundURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );

        return cardUnBlockModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from card sudo Card Make Or Remove Default Api api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        'Something went Wrong! in sudo Card Make Or Remove Default Api info Api',
      );
      return null;
    }
    return null;
  }

  static Future<SudoCardChargesModel?> sudoCardChargesApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.sudoChargeURl}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        SudoCardChargesModel cardChargesModel = SudoCardChargesModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     cardChargesModel.message.success.first.toString());
        return cardChargesModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from sudo Card Charges Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in sudo Card Charges Model');
      return null;
    }
    return null;
  }

  //create card Api method
  static Future<CommonSuccessModel?> sudoCreateCardApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sudoCreateCardURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel createCardModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     createCardModel.message.success.first.toString());
        return createCardModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from create card api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in create Card Model');
      return null;
    }
    return null;
  }

  // sudo card fund Api method
  static Future<CommonSuccessModel?> sudoCardFundApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.sudoCardFundURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from sudo card fund api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  ///>>>>>>>>>>>>>>>>>>>>.. transfer money
  static Future<TransferExistModel?> transferMoneyCheckUserApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.transferCheckUserURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        // Parses `data.exist_user` so the UI can show the verified recipient's
        // name. A not-found (non-200) response is handled by ApiMethod and
        // returns null here.
        return TransferExistModel.fromJson(mapResponse);
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from transfer money check user api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //transfer money info
  static Future<TransferMoneyInfoModel?> transferMoneyInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.transferInfoURl}?lang=${languageSettingsController.selectedLanguage.value}",
        showResult: true,
      );
      if (mapResponse != null) {
        TransferMoneyInfoModel transferMoneyInfoModel =
            TransferMoneyInfoModel.fromJson(mapResponse);
        // CustomSnackBar.error(
        //     transferMoneyInfoModel.message.success.first.toString());
        return transferMoneyInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from transfer money info Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //transfer money confirm
  static Future<CommonSuccessModel?> transferMoneyConfirmApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.transferConfirmURl}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonSuccessModel cardUnblockModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.error(
        //     cardUnblockModel.message.success.first.toString());
        return cardUnblockModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from transfer money confirm api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  /// transaction log
  static Future<TransationLogModel?> getTransactionLogAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.transactionLogURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        TransationLogModel modelData = TransationLogModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from all transaction info  service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //withdraw info
  static Future<WithdrawInfoModel?> withdrawInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.withdrawInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        WithdrawInfoModel withdrawInfoModel = WithdrawInfoModel.fromJson(
          mapResponse,
        );

        return withdrawInfoModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from withdraw info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in withdraw info api');
      return null;
    }
    return null;
  }

  //withdraw dynamic
  static Future<DynamicInputWithdrawModel?> withdrawInsertApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.withdrawInsertURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
      );
      if (mapResponse != null) {
        DynamicInputWithdrawModel result = DynamicInputWithdrawModel.fromJson(
          mapResponse,
        );
        return result;
      }
    } catch (e) {
      log.e('err from money out insert process api service ==> $e');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // withdraw submit
  static Future<CommonSuccessModel?> withdrawSubmitApi({
    required Map<String, String> body,
    required List<String> pathList,
    required List<String> fieldList,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: true).multipartMultiFile(
        "${ApiEndpoint.withdrawConfirmURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
        fieldList: fieldList,
        pathList: pathList,
      );
      if (mapResponse != null) {
        CommonSuccessModel registrationModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        // CustomSnackBar.success(
        //     registrationModel.message.success.first.toString());
        return registrationModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from withdraw submit api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Stripe Gateway
  static Future<AutomaticPaymentSslcommerzModel?> automaticSslcommerzApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentSslcommerzModel automaticPaymentSslcommerzModel =
            AutomaticPaymentSslcommerzModel.fromJson(mapResponse);
        return automaticPaymentSslcommerzModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment sslcommerz Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Bkash Gateway
  static Future<AutomaticBkashModel?> automaticBkashAPi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticBkashModel automaticBkashModel = AutomaticBkashModel.fromJson(
          mapResponse,
        );
        return automaticBkashModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment Bkash Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Stripe Gateway
  static Future<AutomaticPaymentFlutterwaveModel?> automaticFlutterwaveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentFlutterwaveModel automaticPaymentFlutterwaveModel =
            AutomaticPaymentFlutterwaveModel.fromJson(mapResponse);
        return automaticPaymentFlutterwaveModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment flutterwave Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // add money Automatic Payment Stripe Gateway
  static Future<AutomaticPaymentRazorpayModel?> automaticRazorpayApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentRazorpayModel automaticPaymentRazorpayModel =
            AutomaticPaymentRazorpayModel.fromJson(mapResponse);
        return automaticPaymentRazorpayModel;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment razorpay Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  //Automatic Payment Qrpay Gateway
  static Future<AutomaticPaymentRazorpayModel?> automaticQrpayApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        showResult: true,
      );
      if (mapResponse != null) {
        AutomaticPaymentRazorpayModel result =
            AutomaticPaymentRazorpayModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic Payment qrpay Gateway api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  } //

  //Tatum api process
  static Future<TatumGatewayModel?> tatumInsertApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        duration: 15,
        showResult: true,
      );
      if (mapResponse != null) {
        TatumGatewayModel result = TatumGatewayModel.fromJson(mapResponse);
        // CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from tatum api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  /// Tatum confirm process
  static Future<CommonSuccessModel?> tatumConfirmApiProcess({
    required Map<String, dynamic> body,
    required String url,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(url, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from Tatum confirm  api service ==> $e');
      // CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
    return null;
  }

  static Future<CommonPaymentsModel?> coinGateInsertApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        "${ApiEndpoint.addMoneySubmitURL}?lang=${languageSettingsController.selectedLanguage.value}",
        body,
        code: 200,
        duration: 15,
        showResult: true,
      );
      if (mapResponse != null) {
        CommonPaymentsModel coinGateModel = CommonPaymentsModel.fromJson(
          mapResponse,
        );
        //CustomSnackBar.success(coinGateModel.message.success.first.toString());
        return coinGateModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from coingate insert api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
    return null;
  }

  // two fa added
  static Future<TwoFaInfoModel?> getTwoFAInfoAPi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(
        "${ApiEndpoint.twoFAInfoURL}?lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      if (mapResponse != null) {
        TwoFaInfoModel modelData = TwoFaInfoModel.fromJson(mapResponse);

        return modelData;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from twofa api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in twofa info Api');
      return null;
    }
    return null;
  }

  static Future<CommonSuccessModel?> twoFAVerifyAPi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.twoFAVerifyURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel modelData = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(modelData.message.success.first.toString());
        return modelData;
      }
    } catch (e) {
      log.e('err from twoFAVerify api service ==> $e');
      // CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  ///* Two fa submit process api
  static Future<CommonSuccessModel?> twoFaSubmitApiProcess({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.twoFaSubmitURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        return result;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from Two fa submit process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        'Something went Wrong! in Two fa submit process api services',
      );
      return null;
    }
    return null;
  }

  static Future<RemainingBalanceModel?> remainingBalanceAPi(
    String type,
    String attribute,
    String senderAmount,
    String currencyCode,
    int id,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.getRemainingBalance}$type&attribute=$attribute&sender_amount=$senderAmount&currency_code=${LocalStorage.getBaseCurrency()}&charge_id=$id&extra_rate=",
        showResult: true,
      );
      RemainingBalanceModel remainingBalanceModel =
          RemainingBalanceModel.fromJson(mapResponse!);

      return remainingBalanceModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from remaining balance Api service ==> $e 🐞🐞🐞');
      // CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }

  // delete account
  static Future<CommonSuccessModel?> deleteAccountApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.deleteAccountURL, body, code: 200);
      if (mapResponse != null) {
        CommonSuccessModel checkUserModel = CommonSuccessModel.fromJson(
          mapResponse,
        );
        CustomSnackBar.success(checkUserModel.message.success.first.toString());
        return checkUserModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from delete account service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in delete account ');
      return null;
    }
    return null;
  }

  //  Add Money Authorize Submit Api
  static Future<AddMoneyAuthorizeModel?> addMoneyAuthorizeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.addMoneySubmitURL, body, code: 200, showResult: true);
      if (mapResponse != null) {
        AddMoneyAuthorizeModel addMoneyAuthorizeModel =
            AddMoneyAuthorizeModel.fromJson(mapResponse);

        return addMoneyAuthorizeModel;
      }
    } catch (e) {
      log.e('🐞🐞🐞 err from add money Authorize api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  ///* Automatic Authorize Process process api
  static Future<AuthorizeConfirmModel?> automaticAuthorizeProcess({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.submitWithAutomaticAuthorizePaymentURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        AuthorizeConfirmModel result = AuthorizeConfirmModel.fromJson(
          mapResponse,
        );
        return result;
      }
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from automatic submit process api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
}
