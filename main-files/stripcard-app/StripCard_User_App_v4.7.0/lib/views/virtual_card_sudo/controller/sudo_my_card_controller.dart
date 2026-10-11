import 'package:get/get.dart';
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/sudo_models/sudo_card_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";

class VirtualSudoCardController extends GetxController {
  final dashboardController = Get.put(DashBoardController());
  final remainingController = Get.put(RemainingBalanceController());

  // Reactive variables for charge calculations
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;
  RxString cardId = "".obs;
  RxString formCurrency = "".obs;
  RxString baseCurrency = "".obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble getRemainingDailyLimit = 0.0.obs;
  RxDouble getRemainingMonthlyLimit = 0.0.obs;
  RxString selectedIdentityType = "Select Type".obs;
  RxString selectedIdentityTypeCode = "".obs;
  RxString selectedSupportedCurrencyCode = "".obs;
  RxString selectedSupportedCurrencyRate = "".obs;
  RxString selectedSupportedCurrencyName = "Select Currency".obs;
  RxDouble exchangeRate = 0.0.obs;

  List<Option> identityTypeList = [];
  List<SupportedCurrency> supportedCurrencyList = [];

  RxBool isExtraField = false.obs;
  RxDouble totalCharge = 0.00.obs;
  List<String> baseCurrencyList = [];
  RxInt activeIndicatorIndex = 0.obs;

  // State management for loading
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late SudoMyCardModel _sudoMyCardModel;

  SudoMyCardModel get sudoMyCardModel => _sudoMyCardModel;

  @override
  void onInit() {
    super.onInit();
    dashboardController.getDashboardData().then((value) {
      if (dashboardController.dashBoardModel.data.activeVirtualSystem ==
          'sudo') {
        getCardData();
      }
    });
  }

  void updateLimits() {
    double exchangeRate =
        double.tryParse(selectedSupportedCurrencyRate.value) ?? 0.0;
    dailyLimit.value = dailyLimit.value * exchangeRate;
    monthlyLimit.value = monthlyLimit.value * exchangeRate;
    limitMin.value = limitMin.value * exchangeRate;
    limitMax.value = limitMax.value * exchangeRate;
    getRemainingDailyLimit.value =
        remainingController.remainingDailyLimit.value * exchangeRate;
    getRemainingMonthlyLimit.value =
        remainingController.remainingMonthLyLimit.value * exchangeRate;
  }

  // Method to change the indicator index
  void changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  void calculation() {
    // Get the exchange rate for the currency selected
    double ngnValue =
        double.tryParse(selectedSupportedCurrencyRate.value) ?? 0.0;

    // Ensure exchange rate is not zero
    if (ngnValue != 0.0) {
      // Calculate exchange rate
      exchangeRate.value = 1 / ngnValue;

      // Calculate total charge using the fixed charge and percent charge
      totalCharge.value =
          (fixedCharge.value * exchangeRate.value) + percentCharge.value;
    } else {
      // Handle the case when the exchange rate is zero (or invalid)
      exchangeRate.value = 0.0;
      totalCharge.value = percentCharge.value;
    }
  }

  // Bumped whenever the card list (re)loads, so reactive listeners — e.g. the
  // home "YOUR CARDS" section — rebuild once the async fetch completes instead
  // of being stuck on the empty placeholder (the model itself isn't an Rx).
  final RxInt cardsRevision = 0.obs;

  // Method to fetch card data from the API
  Future<SudoMyCardModel> getCardData() async {
    _isLoading.value = true;
    update();

    try {
      await ApiServices.sudoCardInfoApi().then((value) {
        _sudoMyCardModel = value!;
        cardsRevision.value++;

        // Parsing extra fields and supported currencies
        for (var field in _sudoMyCardModel.data.cardExtraFields) {
          if (field.type == "select") {
            identityTypeList.addAll(field.options);
          }
        }

        for (var v in _sudoMyCardModel.data.supportedCurrency) {
          supportedCurrencyList.add(SupportedCurrency(
            id: v.id,
            name: v.name,
            status: v.status,
            rate: v.rate,
            currencySymbol: v.currencySymbol,
            currencyCode: v.currencyCode,
            currencyName: v.currencyName,
            mobileCode: v.mobileCode,
          ));
        }

        // Setting initial values from the card data
        selectedSupportedCurrencyCode.value = _sudoMyCardModel.data.baseCurr;
        cardId.value = _sudoMyCardModel.data.myCard.isEmpty
            ? ""
            : _sudoMyCardModel.data.myCard.first.cardId;
        formCurrency.value = _sudoMyCardModel.data.myCard.isEmpty
            ? ""
            : _sudoMyCardModel.data.myCard.first.currency;
        baseCurrency.value = _sudoMyCardModel.data.baseCurr;
        baseCurrencyList.add(_sudoMyCardModel.data.baseCurr);

        limitMin.value = _sudoMyCardModel.data.cardCharge.minLimit.toDouble();
        limitMax.value = _sudoMyCardModel.data.cardCharge.maxLimit.toDouble();
        isExtraField.value = _sudoMyCardModel.data.cardExtraFieldsStatus;
        percentCharge.value =
            _sudoMyCardModel.data.cardCharge.percentCharge.toDouble();
        fixedCharge.value =
            _sudoMyCardModel.data.cardCharge.fixedCharge.toDouble();
        dailyLimit.value =
            _sudoMyCardModel.data.cardCharge.dailyLimit.toDouble();
        monthlyLimit.value =
            _sudoMyCardModel.data.cardCharge.monthlyLimit.toDouble();
        rate.value = 1.0;

        // Save image for the virtual card
        LocalStorage.saveVirtualImage(
            virtualImage: _sudoMyCardModel.data.cardBasicInfo.cardBg);

        // Set remaining balance controller data
        remainingController.transactionType.value =
            _sudoMyCardModel.data.getRemainingFields.transactionType;
        remainingController.attribute.value =
            _sudoMyCardModel.data.getRemainingFields.attribute;
        remainingController.cardId.value =
            _sudoMyCardModel.data.cardCharge.id;
        remainingController.senderCurrency.value =
            _sudoMyCardModel.data.baseCurr;
        calculation(); // This triggers the total charge calculation

        remainingController.getRemainingBalanceProcess();

        update();
      });
    } catch (error) {
      log.e(error);
    }

    _isLoading.value = false;
    update();
    return _sudoMyCardModel;
  }

  // Method to handle make or remove default process
  final _isDefaultLoading = false.obs;

  bool get isDefaultLoading => _isDefaultLoading.value;
  late CommonSuccessModel _makeOrRemoveDefault;

  CommonSuccessModel get makeOrRemoveDefault => _makeOrRemoveDefault;

  Future<CommonSuccessModel> defaultProcess() async {
    _isDefaultLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {'card_id': cardId.value};

    try {
      await ApiServices.sudoCardMakeOrRemoveDefaultApi(body: inputBody)
          .then((value) {
        _makeOrRemoveDefault = value!;
        update();
        getCardData(); // Refresh data after making or removing default
        update();
      });
    } catch (error) {
      log.e(error);
      update();
    }

    _isDefaultLoading.value = false;
    update();
    return _makeOrRemoveDefault;
  }
}
