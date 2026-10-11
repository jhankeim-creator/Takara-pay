import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/local_storage.dart";
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/my_card_model.dart";
import "package:TAKARA PAY/base/utils/basic_screen_import.dart";
import "package:TAKARA PAY/base/widgets/others/congratulation_widget.dart";
import "package:TAKARA PAY/views/navbar/controller/dashboard_controller.dart";

class FlutterWaveCardController extends GetxController {
  final cardAmountTextController = TextEditingController();
  final RxString cardId = ''.obs;
  final RxString amount = ''.obs;
  final RxString Currency = ''.obs;
  final RxString FromCurrency = ''.obs;
  List<SupportedCurrency> supportedCurrencyList = [];
  RxString selectedSupportedCurrencyCode = "".obs;
  RxString selectedIdentityType = "Select Type".obs;
  RxString selectedIdentityTypeCode = "".obs;
  RxDouble selectedSupportedCurrencyRate = 0.0.obs;
  RxString selectedSupportedCurrencyName = "Select Currency".obs;

  RxString baseCurrency = "".obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble getRemainingDailyLimit = 0.0.obs;
  RxDouble getRemainingMonthlyLimit = 0.0.obs;
  RxDouble exchangeRate = 0.0.obs;

  final dashboardController = Get.put(DashBoardController());

  @override
  void onInit() {
    dashboardController.getDashboardData().then((value) {
      if (dashboardController.dashBoardModel.data.activeVirtualSystem ==
          'flutterwave') {
        getCardData();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    cardAmountTextController.dispose();
    super.onClose();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // Was `late FlutterMyCardModel _myCardModel;` — same LateInitializationError
  // pattern as MoneyOutController (FIX-21). When the user is on a different
  // active virtual system (e.g. Sudo) and never triggers the FlutterWave
  // myCard fetch, this field stays uninitialized and any read crashes.
  FlutterMyCardModel? _myCardModel;

  FlutterMyCardModel? get myCardModel => _myCardModel;
  bool get hasMyCardData => _myCardModel != null;

  // Reactive tick bumped on each card (re)load so the home "YOUR CARDS"
  // section rebuilds when the async fetch finishes (the model isn't an Rx).
  final RxInt cardsRevision = 0.obs;

  Future<FlutterMyCardModel?> getCardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.myCardApi().then((value) {
      _myCardModel = value!;
      cardsRevision.value++;
      final fresh = _myCardModel!;
      cardId.value = fresh.data.myCards.isNotEmpty
          ? fresh.data.myCards.first.cardId.toString()
          : '';
      Currency.value = fresh.data.myCards.isNotEmpty
          ? fresh.data.baseCurr
          : '';
      FromCurrency.value = fresh.data.myCards.isNotEmpty
          ? fresh.data.baseCurr
          : '';

      LocalStorage.saveVirtualImage(
          virtualImage: fresh.data.myCards.isNotEmpty
              ? fresh.data.cardBasicInfo.cardBg
              : '');

      for (var v in fresh.data.supportedCurrency) {
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
      if (fresh.data.supportedCurrency.isNotEmpty) {
        selectedSupportedCurrencyCode.value =
            fresh.data.supportedCurrency.first.currencyCode;
      }
      dailyLimit.value = fresh.data.cardCharge.dailyLimit.toDouble();
      monthlyLimit.value = fresh.data.cardCharge.monthlyLimit.toDouble();
      limitMin.value = fresh.data.cardCharge.minLimit.toDouble();
      limitMax.value = fresh.data.cardCharge.maxLimit.toDouble();
      baseCurrency.value = fresh.data.baseCurr;
      // exchangeRate.value = fresh.data.baseCurrRate.toDouble();

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _myCardModel;
  }

  void limitCalculation() {
    limitMax.value = limitMax.value * selectedSupportedCurrencyRate.value;
    limitMax.value = limitMax.value * selectedSupportedCurrencyRate.value;
  }

  // create card  process
  // Was `late CommonSuccessModel _createCardModel;` — this is THE crash
  // from Bug 1: when /user/my-card/create returns 404 (because of the
  // empty-currency Bug 2 below), the success branch never runs and the
  // `return _createCardModel;` at end of method threw LateInitializationError.
  CommonSuccessModel? _createCardModel;

  CommonSuccessModel? get createCardModel => _createCardModel;
  bool get hasCreateCardData => _createCardModel != null;

  Future<CommonSuccessModel?> createCardProcess(context) async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'card_amount': cardAmountTextController.text,
      'currency': selectedSupportedCurrencyCode.value.isEmpty
          ? baseCurrency.value
          : selectedSupportedCurrencyCode.value,
      'from_currency': baseCurrency.value,
    };
    await ApiServices.createCardApi(body: inputBody).then((value) {
      _createCardModel = value!;
      update();

      StatusScreen.show(
        context: context,
        subTitle: Strings.yourCardSuccess.tr,
        onPressed: () {
          Get.offAllNamed(Routes.bottomNavBarScreen);
        },
      );
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
    });

    _isLoading.value = false;
    update();
    return _createCardModel;
  }
}
