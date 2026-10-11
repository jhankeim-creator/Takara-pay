import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/charge_strowallet_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_card_holder_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_card_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_details_controller.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_transaction_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_webhook_model.dart";
import "package:stripcard/base/api/method/api_method.dart";
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/api/endpoint/api_endpoint.dart";


    
     

// Outcome of GET /user/strowallet-card/get/card-holder. The backend answers
// with a 400 (not 200) when no card-holder has been created yet — an
// expected state for new users, not a failure — so this is classified by
// STATUS CODE + response shape only, never by matching the (translated)
// error message text.
enum StrowalletCardHolderFetchStatus { exists, notCreated, failed }

class StrowalletCardHolderFetchResult {
  const StrowalletCardHolderFetchResult._(this.status, this.model);
  final StrowalletCardHolderFetchStatus status;
  final StrowalletCardHolderModel? model;

  const StrowalletCardHolderFetchResult.exists(StrowalletCardHolderModel model)
      : this._(StrowalletCardHolderFetchStatus.exists, model);
  const StrowalletCardHolderFetchResult.notCreated()
      : this._(StrowalletCardHolderFetchStatus.notCreated, null);
  const StrowalletCardHolderFetchResult.failed()
      : this._(StrowalletCardHolderFetchStatus.failed, null);
}

class StrowalletApiServices {
  // GET card-holder: confirmed (device log) that the backend answers 400 for
  // "Card Holder Not Created Yet. Please create a card holder first." That
  // status is declared silent on the request below so ApiMethod doesn't show
  // its error snackbar for an expected new-user state, and the raw body is
  // classified here — never by the (translated) message text:
  //   mapResponse == null                                    -> failed
  //   data == null AND message.error is a non-empty List     -> notCreated
  //   data == null in any other shape (e.g. message.success) -> failed
  //   data != null -> parse StrowalletCardHolderModel; throws -> failed (caught below)
  static const int _cardHolderNotCreatedStatus = 400;

  static Future<StrowalletCardHolderFetchResult> strowalletGetCardHolderApi() async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.strowalletGetCardHolderURL,
        code: 200,
        silentStatusCodes: const [_cardHolderNotCreatedStatus],
      );
      if (mapResponse == null) {
        return const StrowalletCardHolderFetchResult.failed();
      }

      final data = mapResponse['data'];
      if (data == null) {
        final message = mapResponse['message'];
        final error = message is Map ? message['error'] : null;
        final isNotCreatedShape = error is List && error.isNotEmpty;
        return isNotCreatedShape
            ? const StrowalletCardHolderFetchResult.notCreated()
            : const StrowalletCardHolderFetchResult.failed();
      }

      final model = StrowalletCardHolderModel.fromJson(mapResponse);
      if (model.data.cardHolder == null) {
        // data present but no card_holder inside it — an unexpected shape,
        // never treated as "safe to show the editable form".
        return const StrowalletCardHolderFetchResult.failed();
      }
      return StrowalletCardHolderFetchResult.exists(model);
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet get card holder api service ==> $e 🐞🐞🐞');
      return const StrowalletCardHolderFetchResult.failed();
    }
  }

  // strowallet card info api
  static Future<StrowalletCardModel?> strowalletCardInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.strowalletCardURL,
        code: 200,
        showResult: false,
      );
      StrowalletCardModel strowalletCardInfoModel =
          StrowalletCardModel.fromJson(mapResponse!);

      return strowalletCardInfoModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet card info api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }
  
   
  // Card details api
  static Future<StrowalletCardDetailsModel?> strowalletCardDetailsApi(
      String id) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.strowalletCardDetailsURL + id}&lang=${languageSettingsController.selectedLanguage.value}",
        code: 200,
        showResult: false,
      );
      StrowalletCardDetailsModel cardDetailsModel =
          StrowalletCardDetailsModel.fromJson(mapResponse!);

      return cardDetailsModel;
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from strowallet card details api service ==> $e 🐞🐞🐞');
        CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }

 //strowallet card inactive api
  static Future<CommonSuccessModel?> strowalletInactiveApi(
    {required Map<String, dynamic> body}) async {
      Map<String, dynamic>? mapResponse;
        try {
          mapResponse = await ApiMethod(isBasic: false).post(
          ApiEndpoint.strowalletCardUnBlockURL,
          body,
          code: 200,
          showResult: false,
        );
      CommonSuccessModel cardUnBlockModel =
        CommonSuccessModel.fromJson(mapResponse!);

      return cardUnBlockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from inactive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }

  // strowallet card active api
  static Future<CommonSuccessModel?> strowalletpeActiveApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.strowalletCardBLockURL,
        body,
        code: 200,
        showResult: false,
      );
      CommonSuccessModel cardUnBlockModel =
          CommonSuccessModel.fromJson(mapResponse!);

      return cardUnBlockModel;
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from strowallet card active Api api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }



  // Card Fund Api Method
    static Future<CommonSuccessModel?> strowalletCardFundApi(
      {required Map<String, dynamic> body}) async {
       Map<String, dynamic>? mapResponse;
          try {
          mapResponse = await ApiMethod(isBasic: false).post(
          ApiEndpoint.strowalletCardFundURL,
          body,
          showResult: true,
      );
      CommonSuccessModel cardFundModel =
          CommonSuccessModel.fromJson(mapResponse!);
      // CustomSnackBar.success(cardFundModel.message.success.first.toString());
      return cardFundModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet Fund api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong! in strowallet Fund Model');
      return null;
    }
  }

  // Withdraw card balance back to wallet (POST /user/strowallet-card/withdraw)
  // body: card_id, withdraw_amount, currency, from_currency
  static Future<CommonSuccessModel?> strowalletCardWithdrawApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.strowalletWithdrawCardURL,
        body,
        showResult: true,
      );
      CommonSuccessModel cardWithdrawModel =
          CommonSuccessModel.fromJson(mapResponse!);
      return cardWithdrawModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet Withdraw api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>()
          .getTranslation(Strings.somethingWentWrong));
      return null;
    }
  }

  static Future<StrowalletChargeModel?> strollerCardChargesApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.strowalletCardChargeURL,
        showResult: true,
      );
      StrowalletChargeModel cardChargesModel =
          StrowalletChargeModel.fromJson(mapResponse!);
      return cardChargesModel;
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from sudo strowallet Charges Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }

  // strowallet create card Api method
  static Future<CommonSuccessModel?> strowalletBuyCardApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.strowalletBuyCardURL,
        body,
        showResult: true,
      );
      // On a 4xx, ApiMethod already surfaced the real backend reason (e.g.
      // "The amount usd must be at least 3.") and returned null — don't parse a
      // null map and overwrite it with a generic "Something went Wrong!".
      if (mapResponse == null) return null;
      CommonSuccessModel cardUnblockModel =
          CommonSuccessModel.fromJson(mapResponse);
      CustomSnackBar.success(cardUnblockModel.message.success.first.toString());
      return cardUnblockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from strowallet card buy api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
  }

  // strowallet card make or remove default api
  static Future<CommonSuccessModel?> strowalletCardMakeOrRemoveDefaultApi(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.strowalletCardMakeOrRemoveDefaultFundURL,
        body,
        code: 200,
        showResult: false,
      );

      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e(
         '🐞🐞🐞 err from card strowallet Card Make Or Remove Default Api api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(Get.find<LanguageController>().getTranslation( Strings.somethingWentWrong));
      return null;
    }
    return null;
  }

  //strowallet card transaction method
  static Future<StrowalletCardTransactionModel?> strowalletCardTransactionApi(
      String cardId) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.strowalletCardTransactionURL}$cardId",
        showResult: true,
      );
      StrowalletCardTransactionModel cardTransactionModel =
          StrowalletCardTransactionModel.fromJson(mapResponse!);

      return cardTransactionModel;
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from my strowallet Card Transaction Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  } 

  //strowallet card transaction method
  static Future<WebhookLogModel?> strowalletWebhookLogsApi(
      String cardId) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.webhookLogsURL}$cardId",
        showResult: true,
      );
      WebhookLogModel cardTransactionModel =
          WebhookLogModel.fromJson(mapResponse!);

      return cardTransactionModel;
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from my strowallet webhooks api  Api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }
}
