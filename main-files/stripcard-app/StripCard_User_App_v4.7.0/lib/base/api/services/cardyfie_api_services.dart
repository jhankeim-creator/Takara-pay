import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/virtual_card_cardyfie/model/my_card_model_cardyfie.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/card_details_model_cardyfie.dart";
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/card_transaction_model_cardyfie.dart";
import "package:stripcard/base/api/model/virtual_card/cardyfie_model/my_card_model_cardyfie.dart";
import "package:stripcard/base/api/method/api_method.dart";
import "package:stripcard/base/utils/custom_snackbar.dart";
import "package:stripcard/base/api/endpoint/api_endpoint.dart";

class CardyfieApiServices {
  // cardyfie card info api
  // static Future<CreateCardInfoModelCardyfie?>
  // cardyfieCardInfoWalletsApi() async {
  //   Map<String, dynamic>? mapResponse;
  //   try {
  //     mapResponse = await ApiMethod(
  //       isBasic: false,
  //     ).get(ApiEndpoint.cardyfieMyCards, code: 200, showResult: false);
  //     CreateCardInfoModelCardyfie createCardInfoModelCardyfie =
  //         CreateCardInfoModelCardyfie.fromJson(mapResponse!);
  //     return createCardInfoModelCardyfie;
  //   } catch (e) {
  //     log.e('🐞🐞🐞 err from cardyfie my card  api service ==> $e 🐞🐞🐞');
  //     CustomSnackBar.error(
  //       Get.find<LanguageController>().getTranslation(
  //         Strings.somethingWentWrong,
  //       ),
  //     );
  //     return null;
  //   }
  // }

  // cardyfie card info api
  static Future<MyCardCardyfieModel?> cardyfieCardInfoApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get(ApiEndpoint.cardyfieMyCards, code: 200, showResult: true);
      MyCardCardyfieModel myCard = MyCardCardyfieModel.fromJson(mapResponse!);
      return myCard;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie my card  api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }

  // card details api
  static Future<CardDetailsModelCardyfie?> cardyfieCardDetailsApi(
    String id,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        "${ApiEndpoint.cardyfieCardDetails + id}",
        code: 200,
        showResult: false,
      );
      CardDetailsModelCardyfie cardDetailsModel =
          CardDetailsModelCardyfie.fromJson(mapResponse!);

      return cardDetailsModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie card details api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }

  //cardyfie card inactive api
  static Future<CommonSuccessModel?> cardyfieFreezeApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.cardyfieFreezeUnfreeze,
        body,
        code: 200,
        showResult: false,
      );
      CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );

      return cardUnBlockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from inactive api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }

  // cardyfie card active api
  static Future<CommonSuccessModel?> cardyfiepeActiveApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.cardyfieDepositCard,
        body,
        code: 200,
        showResult: false,
      );
      CommonSuccessModel cardUnBlockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );

      return cardUnBlockModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from cardyfie card active Api api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }

  // Card Fund Api Method
  static Future<CommonSuccessModel?> cardyfieCardFundApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.cardyfieDepositCard, body, showResult: true);
      CommonSuccessModel cardFundModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );
      // CustomSnackBar.success(cardFundModel.message.success.first.toString());
      return cardFundModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie Fund api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Please Try Again Later');
      return null;
    }
  }

  // Card Fund Api Method
  static Future<CommonSuccessModel?> cardyfieCardWithdrawApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.cardyfieWithdrawCard, body, showResult: true);
      CommonSuccessModel cardFundModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );
      // CustomSnackBar.success(cardFundModel.message.success.first.toString());
      return cardFundModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie withdraw api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Your card does not have enough funds');
      return null;
    }
  }

  // static Future<cardyfieChargeModel?> strollerCardChargesApi() async {
  //   Map<String, dynamic>? mapResponse;
  //   try {
  //     mapResponse = await ApiMethod(
  //       isBasic: false,
  //     ).get(ApiEndpoint.cardyfieCardChargeURL, showResult: true);
  //     cardyfieChargeModel cardChargesModel = cardyfieChargeModel.fromJson(
  //       mapResponse!,
  //     );
  //     return cardChargesModel;
  //   } catch (e) {
  //     log.e('🐞🐞🐞 err from sudo cardyfie Charges Api service ==> $e 🐞🐞🐞');
  //     CustomSnackBar.error(
  //       Get.find<LanguageController>().getTranslation(
  //         Strings.somethingWentWrong,
  //       ),
  //     );
  //     return null;
  //   }
  // }

  // cardyfie create card Api method
  static Future<CommonSuccessModel?> cardyfieCreateCardApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).post(ApiEndpoint.cardyfieCreateCard, body, showResult: true);
      CommonSuccessModel cardUnblockModel = CommonSuccessModel.fromJson(
        mapResponse!,
      );
      CustomSnackBar.success(cardUnblockModel.message.success.first.toString());
      return cardUnblockModel;
    } catch (e) {
      log.e('🐞🐞🐞 err from cardyfie card buy api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error(
        Get.find<LanguageController>().getTranslation(
          Strings.somethingWentWrong,
        ),
      );
      return null;
    }
  }

  // cardyfie card make or remove default api
  static Future<CommonSuccessModel?> cardyfieCardMakeOrRemoveDefaultApi({
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.cardyfieMakeRemoveDefault,
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
        '🐞🐞🐞 err from card cardyfie Card Make Or Remove Default Api api service ==> $e 🐞🐞🐞',
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

  //cardyfie card transaction method
  static Future<CardTransactionModelCardyfie?> cardyfieCardTransactionApi(
    String cardId,
  ) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(
        isBasic: false,
      ).get("${ApiEndpoint.cardyfieTransactionCard}$cardId", showResult: true);
      CardTransactionModelCardyfie cardTransactionModel =
          CardTransactionModelCardyfie.fromJson(mapResponse!);

      return cardTransactionModel;
    } catch (e) {
      log.e(
        '🐞🐞🐞 err from my cardyfie Card Transaction Api service ==> $e 🐞🐞🐞',
      );
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
  }
}
