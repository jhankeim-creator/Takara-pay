import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/model/virtual_card/stripe_models/stripe_card_sensitive_model.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/stripe_models/stripe_card_info_model.dart";
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";

class StripeTwoController extends GetxController {
  final dashbaordController = Get.put(DashBoardController());
  final remainingController = Get.put(RemainingBalanceController());
  final fundAmountController = TextEditingController();

  RxString cardId = "".obs;
  final RxString amount = ''.obs;
  final RxString Currency = ''.obs;
  RxInt activeIndicatorIndex = 0.obs;
  RxString baseCurrency = "".obs;

  RxDouble totalPay = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;
  RxDouble totalCharge = 0.00.obs;

  RxInt limitMin = 0.obs;
  RxDouble getLimitMin = 0.0.obs;
  RxDouble getLimitMax = 0.0.obs;
  RxInt dallyLimit = 0.obs;
  RxDouble getDallyLimit = 0.0.obs;
  RxDouble getMonthlyLimit = 0.0.obs;
  RxInt monthlyLimit = 0.obs;
  RxDouble getRemainingMonthLyLimit = 0.0.obs;
  RxDouble getRemainingDailyLimit = 0.0.obs;

  RxString selectedSupportedCurrency = "Select Method".obs;
  RxString code = "".obs;
  RxDouble selectedSupportedCurrencyRate = 0.0.obs;

  List<SupportedCurrency> supportedCurrencyList = [];

  @override
  void onInit() {
    dashbaordController.getDashboardData().then((value) {
      if (dashbaordController.dashBoardModel.data.activeVirtualSystem ==
          'stripe') {
        getStripeCardData();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    fundAmountController.dispose();
    super.onClose();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late StripeCardInfoModel _stripeCardModel;

  StripeCardInfoModel get stripeCardModel => _stripeCardModel;

  // Reactive tick bumped on each card (re)load so the home "YOUR CARDS"
  // section rebuilds when the async fetch finishes (the model isn't an Rx).
  final RxInt cardsRevision = 0.obs;

  Future<StripeCardInfoModel> getStripeCardData() async {
    _isLoading.value = true;
    update();
    await ApiServices.stripeCardInfoApi().then((value) {
      _stripeCardModel = value!;
      cardsRevision.value++;

      dallyLimit.value = stripeCardModel.data.cardCharge.dailyLimit;
      monthlyLimit.value = stripeCardModel.data.cardCharge.monthlyLimit;

      for (var sCurrency in _stripeCardModel.data.supportedCurrency) {
        supportedCurrencyList.add(sCurrency);
      }

      updateLimits();

      if (_stripeCardModel.data.myCard.isNotEmpty) {
        cardId.value = _stripeCardModel.data.myCard.first.cardId;
        Currency.value = _stripeCardModel.data.myCard.first.currency;
        updateLimits();
      }
      LocalStorage.saveVirtualImage(
          virtualImage: stripeCardModel.data.cardBasicInfo.cardBg);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _stripeCardModel;
  }

  Future<StripeCardInfoModel> getStripeNoLoadingCardData() async {
    update();

    await ApiServices.stripeCardInfoApi().then((value) {
      _stripeCardModel = value!;
      for (var sCurrency in _stripeCardModel.data.supportedCurrency) {
        supportedCurrencyList.add(sCurrency);
        updateLimits();
      }
      if (_stripeCardModel.data.myCard.isNotEmpty) {}
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    update();
    return _stripeCardModel;
  }

  void updateLimits() {
    stripeCardModel.data;
    var charge = stripeCardModel.data.cardCharge;

    String cleanMaxLimit = charge.maxLimit.replaceAll(RegExp(r'[^0-9.]'), '');
    double maxLimit = double.tryParse(cleanMaxLimit) ?? 0.0;

    getDallyLimit.value =
        charge.dailyLimit * selectedSupportedCurrencyRate.value;

    getMonthlyLimit.value =
        charge.monthlyLimit * selectedSupportedCurrencyRate.value;

    getLimitMin.value = charge.minLimit * selectedSupportedCurrencyRate.value;

    getLimitMax.value = maxLimit * selectedSupportedCurrencyRate.value;

    getRemainingDailyLimit.value =
        remainingController.remainingDailyLimit.value *
            selectedSupportedCurrencyRate.value;
    getRemainingMonthLyLimit.value =
        remainingController.remainingMonthLyLimit.value *
            selectedSupportedCurrencyRate.value;
  }

  final _isBuyCardLoading = false.obs;

  bool get isBuyCardLoading => _isBuyCardLoading.value;
  late CommonSuccessModel _buyCardModel;

  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel> buyCardProcess(context) async {
    _isBuyCardLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "card_amount": fundAmountController.text,
      "currency": selectedSupportedCurrency.value,
      "from_currency": LocalStorage.getBaseCurrency(),
    };
    await ApiServices.stripeBuyCardApi(body: inputBody).then((value) {
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
    }).catchError((onError) {
      log.e(onError);
      update();
    });

    _isBuyCardLoading.value = false;
    update();
    return _buyCardModel;
  }

  ///  get stripe sensitive info
  final _isSensitiveLoading = false.obs;

  bool get isSensitiveLoading => _isSensitiveLoading.value;
  late StripeSensitiveModel _stripeSensitiveModel;

  StripeSensitiveModel get stripeSensitiveModel => _stripeSensitiveModel;

  Future<StripeSensitiveModel> getStripeSensitiveInfo(
      context, String cardId) async {
    _isSensitiveLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "card_id": cardId,
    };
    await ApiServices.stripeSensitiveApi(body: inputBody).then((value) {
      _stripeSensitiveModel = value!;
      update();

      StatusScreen.show(
        context: context,
        subTitle: Strings.yourCardSuccess.tr,
        onPressed: () {
          Get.offAllNamed(Routes.bottomNavBarScreen);
        },
      );
      update();
    }).catchError((onError) {
      log.e(onError);
      update();
    });

    _isSensitiveLoading.value = false;
    update();
    return _stripeSensitiveModel;
  }

  calculation() {
    CardCharge data = _stripeCardModel.data.cardCharge;
    double amount = 0.0;

    if (fundAmountController.text.isNotEmpty) {
      amount = double.parse(fundAmountController.text);
    }
    percentCharge.value = ((amount / 100) * data.percentCharge);
    totalCharge.value =
        (double.parse(_stripeCardModel.data.cardCharge.fixedCharge.toString()) *
                exchangeRate.value) +
            percentCharge.value;

    //total pay data
    totalPay.value = amount +
        _stripeCardModel.data.cardCharge.fixedCharge +
        percentCharge.value;
  }
}
