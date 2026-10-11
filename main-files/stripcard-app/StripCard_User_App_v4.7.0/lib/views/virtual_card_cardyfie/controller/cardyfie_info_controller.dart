import 'package:intl/intl.dart';
import "package:TAKARA PAY/base/api/services/cardyfie_api_services.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_add_fund_controller.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/cardyfie_model/card_create_info_model_cardyfie.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/cardyfie_model/my_card_model_cardyfie.dart";

import "package:TAKARA PAY/base/api/model/virtual_card/strowallet_models/createcard_strowallet_info_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/strowallet_models/strowallet_card_model.dart"
    hide CardCharge, UserWallet, SupportedCurrency, MyCard;

import "package:TAKARA PAY/base/api/services/strowallet_api_services.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";
import "package:TAKARA PAY/base/utils/request_process.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/inputs/image_widget.dart";
import "package:TAKARA PAY/base/widgets/inputs/number_input-widget.dart";
import "package:TAKARA PAY/base/widgets/inputs/primary_input_filed.dart";
import "package:TAKARA PAY/base/widgets/others/congratulation_widget.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";
import "package:TAKARA PAY/views/profile/controller/update_profile_controller.dart";

class VirtualCardyfieCardController extends GetxController {
  final dashboardController = Get.put(DashBoardController());
  final updateProfileController = Get.put(UpdateProfileController());
  final fundAmountController = TextEditingController();
  final remainingController = Get.put(RemainingBalanceController());
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final identifyNumberController = TextEditingController();
  final houseNumberController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  // final addWithdrawController = Get.put(CardyfieWithdrawFundController());
  // final addFundController = Get.put(CardyfieAddFundController());
  final cardHolderNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final phoneController = TextEditingController();
  final lineController = TextEditingController();
  final countryController = TextEditingController();
  final idTypeController = TextEditingController();
  RxString baseCurrency = "".obs;
  RxString cardCurrency = "".obs;
  RxString cardyfieCardUIId = "".obs;
  RxString cardBgColor = "".obs;
  RxInt activeIndicatorIndex = 0.obs;
  RxInt cardCreateLimit = 0.obs;

  //from currency rate
  RxDouble fromCurrencyRate = 0.0.obs;
  RxDouble cardCurrencyRate = 0.0.obs;
  RxDouble totalCharges = 1.0.obs;

  RxDouble totalCharge = 0.0.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
  // RxDouble amount = 0.00.obs;

  RxString selectedCountry = 'Select Country'.obs;
  RxString countryISO2 = ''.obs;
  final RxString selectTypeName = 'Select Type'.obs;
  final RxString selectTypeSlug = ''.obs;
  // for customer create
  final List<Map<String, String>> identityList = [
    {'name': 'National ID Card (NID)', 'slug': 'nid'},
    {'name': 'Passport', 'slug': 'passport'},
    {'name': 'Bank Verification Number', 'slug': 'bvn'},
  ];

  // for card tier
  final RxString selectTierName = 'Select Tier'.obs;
  final RxString selectTierSlug = ''.obs;
  final List<Map<String, String>> cardTierList = [
    {'name': 'Universal', 'slug': 'universal'},
    {'name': 'Platinum', 'slug': 'platinum'},
  ];
  // for card type
  final RxString selectCardTypeName = 'Select Card Type'.obs;
  final RxString selectCardTypeSlug = ''.obs;
  final List<Map<String, String>> cardTypeList = [
    {'name': 'Visa', 'slug': 'visa'},
    {'name': 'MasterCard', 'slug': 'masterCard'},
  ];
  RxList<String> listImagePath = <String>[].obs;
  RxList<String> listFieldName = <String>[].obs;

  RxBool hasFile = false.obs;
  RxString appBarTitle = "".obs;

  //from currency
  RxString fromCurrency = "".obs;
  Rxn<UserWallet> selectMainWallet = Rxn<UserWallet>();
  List<UserWallet> walletsList = [];
  RxList<MyCard> cardyfieCardList = <MyCard>[].obs;

  //supported currency
  RxString supportedCurrencyCode = "".obs;
  Rxn<SupportedCurrency> selectSupportedCurrency = Rxn<SupportedCurrency>();
  List<SupportedCurrency> supportedCurrencyList = [];

  @override
  void onInit() {
    dashboardController.getDashboardData().then((value) {
      if (dashboardController.dashBoardModel.data.activeVirtualSystem ==
          'cardyfie') {
        print('sdfasdfsadfsadf');
        getCardyfieCardData().then((value) => cardyfieCardCreatePageInfo());
        // customerCreateProcess().then((v) => cardyfieCardCreatePageInfo());
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    fundAmountController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    identifyNumberController.dispose();
    houseNumberController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    cityController.dispose();
    addressController.dispose();
    cardHolderNameController.dispose();
    idNumberController.dispose();
    phoneController.dispose();
    lineController.dispose();
    countryController.dispose();
    idTypeController.dispose();
    super.onClose();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late MyCardCardyfieModel _cardyfieCardModel;
  MyCardCardyfieModel get cardyfieCardModel => _cardyfieCardModel;

  // Reactive tick bumped on each card (re)load so the home "YOUR CARDS"
  // section rebuilds when the async fetch finishes (the model isn't an Rx).
  final RxInt cardsRevision = 0.obs;

  Future<MyCardCardyfieModel> getCardyfieCardData() async {
    _isLoading.value = true;
    update();

    await CardyfieApiServices.cardyfieCardInfoApi()
        .then((value) {
          _cardyfieCardModel = value!;
          cardsRevision.value++;

          cardBgColor.value = _cardyfieCardModel.data.cardBasicInfo.cardBg;
          cardCreateLimit.value = _cardyfieCardModel.data.cardBasicInfo.cardCreateLimit;

          cardyfieCardList.value = _cardyfieCardModel.data.myCards ?? [];

          if (_cardyfieCardModel.data.myCards!.isNotEmpty) {
            cardyfieCardUIId.value =
                _cardyfieCardModel.data.myCards!.first.ulid;
          }
          walletsList.clear();
          baseCurrency.value = _cardyfieCardModel.data.baseCurr;
          fromCurrency.value =
              _cardyfieCardModel.data.userWallet.first.currency.code;
          selectMainWallet.value = _cardyfieCardModel.data.userWallet.first;
          fromCurrencyRate.value =
              _cardyfieCardModel.data.userWallet.first.currency.rate
                  ?.toDouble() ??
              0.0;

          for (var element in _cardyfieCardModel.data.userWallet) {
            walletsList.add(
              UserWallet(
                balance: element.balance,
                currency: element.currency,
                status: element.status,
              ),
            );
          }

          supportedCurrencyList.clear();
          supportedCurrencyCode.value =
              _cardyfieCardModel.data.supportedCurrency.first.currencyCode;
          selectSupportedCurrency.value =
              _cardyfieCardModel.data.supportedCurrency.first;
          cardCurrencyRate.value =
              _cardyfieCardModel.data.supportedCurrency.first.rate
                  ?.toDouble() ??
              0.0;

          for (var element in _cardyfieCardModel.data.supportedCurrency) {
            supportedCurrencyList.add(
              SupportedCurrency(
                id: element.id,
                name: element.name,
                mobileCode: element.mobileCode,
                currencyName: element.currencyName,
                currencyCode: element.currencyCode,
                currencySymbol: element.currencySymbol,
                rate: element.rate,
                status: element.status,
              ),
            );
          }

          //start remaing get
          remainingController.transactionType.value =
              _cardyfieCardModel.data.getRemainingFields.transactionType;
          remainingController.attribute.value =
              _cardyfieCardModel.data.getRemainingFields.attribute;
          remainingController.cardId.value = 1;
          remainingController.senderAmount.value = "0";
          remainingController.senderCurrency.value =
              _cardyfieCardModel.data.userWallet.first.currency.code;
          remainingController.getRemainingBalanceProcess();
          _calculation();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isLoading.value = false;
    update();
    return _cardyfieCardModel;
  }

  //>> with out loading
  Future<MyCardCardyfieModel> getCardyfieCardInfo() async {
    update();

    await CardyfieApiServices.cardyfieCardInfoApi()
        .then((value) {
          _cardyfieCardModel = value!;

          if (_cardyfieCardModel.data.myCards!.isNotEmpty) {
            cardyfieCardUIId.value =
                _cardyfieCardModel.data.myCards!.first.ulid;
          }
          _calculation();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    update();
    return _cardyfieCardModel;
  }

  ///  >>>>>> Start buyCard process
  final _isBuyCardLoading = false.obs;
  bool get isBuyCardLoading => _isBuyCardLoading.value;
  late CommonSuccessModel _buyCardModel;
  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel> issueCardProcess(context) async {
    _isBuyCardLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "name_on_card": cardHolderNameController.text,
      "card_tier": selectTierSlug.value,
      "card_type": selectCardTypeSlug.value,
      "currency": supportedCurrencyCode.value,
      "from_currency": fromCurrency.value,
    };
    await CardyfieApiServices.cardyfieCreateCardApi(body: inputBody)
        .then((value) {
          _buyCardModel = value!;
          update();

          StatusScreen.show(
            context: context,
            subTitle: Strings.yourCardSuccess.tr,
            onPressed: () {
              Get.offAllNamed(Routes.bottomNavBarScreen);
            },
          );

          update();
        })
        .catchError((onError) {
          log.e(onError);
          update();
        });
    _isBuyCardLoading.value = false;
    update();
    return _buyCardModel;
  }

  void _calculation() {
    CardCharge data = _cardyfieCardModel.data.cardCharge;

    double amount = 0.0;

    if (fundAmountController.text.isNotEmpty) {
      try {
        amount = double.parse(fundAmountController.text);
      } catch (e) {
        // print('Error parsing double: $e');
      }
    }

    // percentCharge.value = ((amount / 100) * );
    // totalCharge.value =
    //     double.parse(data.universalCardIssuesFee.toString()) +
    //     percentCharge.value;
    // totalPay.value = amount + totalCharge.value;
  }

  String getDay(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('dd').format(startDate);
    return date.toString();
  }

  String getMonth(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('MMMM').format(startDate);
    return date.toString();
  }

  // flutterwave make card default options
  final _isMakeDefaultLoading = false.obs;

  bool get isMakeDefaultLoading => _isMakeDefaultLoading.value;

  late CommonSuccessModel _cardDefaultModel;

  CommonSuccessModel get cardDefaultModel => _cardDefaultModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> makeCardDefaultProcess(String cardId) async {
    _isMakeDefaultLoading.value = true;
    Map<String, dynamic> inputBody = {'card_id': cardId};

    update();

    await CardyfieApiServices.cardyfieCardMakeOrRemoveDefaultApi(
          body: inputBody,
        )
        .then((value) {
          _cardDefaultModel = value!;
          getCardyfieCardData();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isMakeDefaultLoading.value = false;
    update();
    return _cardDefaultModel;
  }

  final _isCreateCardInfoLoading = false.obs;
  bool get isCreateCardInfoLoading => _isCreateCardInfoLoading.value;

  late CreateCardInfoModelCardyfie _createCardPageInfoModelCardyfie;
  CreateCardInfoModelCardyfie get createCardPageInfoModelCardyfie =>
      _createCardPageInfoModelCardyfie;

  Future<CreateCardInfoModelCardyfie?> cardyfieCardCreatePageInfo() async {

    return RequestProcess().request<CreateCardInfoModelCardyfie>(
      fromJson: CreateCardInfoModelCardyfie.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCreatePageInfo,
      isLoading: _isCreateCardInfoLoading,
      onSuccess: (value) {
      
        _createCardPageInfoModelCardyfie = value!;

        // final data = _createCardPageInfoModelCardyfie.data.customerExist;
        if (_createCardPageInfoModelCardyfie.data.customerExistStatus) {
          appBarTitle.value = Strings.createCard;
        } else {
          appBarTitle.value = Get.find<LanguageController>().getTranslation(
            Strings.createCardCustomer,
          );
        }
      },
    );
  }

  /// Customer Create
  final _isCustomerCreateLoading = false.obs;
  bool get isCustomerCreateLoading => _isCustomerCreateLoading.value;

  late CommonSuccessModel _commonSuccessModel;
  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  Future<CommonSuccessModel?> customerCreateProcess() async {
    Map<String, dynamic> inputBody = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'date_of_birth': dateOfBirthController.text,
      'identity_type': selectTypeSlug.value,
      'identity_number': identifyNumberController.text,
      'house_number': houseNumberController.text,
      'country': countryISO2.value,
      'city': cityController.text,
      'state': stateController.text,
      'zip_code': zipcodeController.text,
      'address': addressController.text,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCreateCustomer,
      isLoading: _isCustomerCreateLoading,
      method: HttpMethod.POST,
      fieldList: listFieldName,
      pathList: listImagePath,
      showSuccessMessage: true,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        Get.offAllNamed(Routes.bottomNavBarScreen);
        _commonSuccessModel = value!;
      },
    );
  }

  ///
  final _isStatusLoading = false.obs;
  bool get isStatusLoading => _isStatusLoading.value;

  late CommonSuccessModel _cardyfieUpdateModel;
  CommonSuccessModel get cardyfieUpdateModel => _cardyfieUpdateModel;

  Future<CommonSuccessModel?> customerUpdateProcessProcess() async {
    Map<String, dynamic> inputBody = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'email': emailController.text,
      'date_of_birth': dateOfBirthController.text,
      'identity_type': selectTypeSlug.value,
      'identity_number': identifyNumberController.text,
      'house_number': houseNumberController.text,
      'country': countryISO2.value,
      'city': cityController.text,
      'state': stateController.text,
      'zip_code': zipcodeController.text,
      'address': addressController.text,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieUpdateCustomer,
      isLoading: _isCustomerCreateLoading,
      method: HttpMethod.POST,
      fieldList: listFieldName,
      pathList: listImagePath,
      showSuccessMessage: true,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

  // testing

  final _isCloseLoading = false.obs;
  bool get isCloseLoading => _isCloseLoading.value;

  late CommonSuccessModel _closeModel;
  CommonSuccessModel get closeModel => _closeModel;

  Future<CommonSuccessModel?> closeProcess() async {
    Map<String, dynamic> inputBody = {'card_id': cardyfieCardUIId.value};

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieCloseCard,
      isLoading: _isCustomerCreateLoading,
      method: HttpMethod.POST,
      showSuccessMessage: true,
      showResult: true,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

  //
  updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }
}
