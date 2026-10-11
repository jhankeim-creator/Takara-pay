import 'package:get/get.dart';

import "package:TAKARA PAY/base/api/model/virtual_card/card_charges_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/card_charges_model.dart" as ccm;
import "package:TAKARA PAY/base/api/model/virtual_card/my_card_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/routes/routes.dart";

class CreateCardController extends GetxController {
  List<SupportedCurrency> supportedCurrencyList = [];

  RxDouble cardChare = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble totalCharge = 0.0.obs;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onInit() {
    _getCardChargesData();
    super.onInit();
  }

  goToCreateNewCardPreviewScreen() {
    Get.toNamed(Routes.createNewCardPreviewScreen);
  }

  RxString selectItem = ''.obs;
  List<String> keyboardItemList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<'
  ];
  List currencyList = ['USD', 'BDT'];
  List gatewayList = ['Paypal', 'Stripe'];

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  /// Set to true whenever `/api/user/my-card/charges` fails (404, network,
  /// parse error). UI surfaces this as an inline "limits unavailable" notice.
  RxBool chargesUnavailable = false.obs;

  // ── Card charges info ────────────────────────────────────────────────
  // Was `late CardChargesModel _cardChargesModel;` — that caused
  // LateInitializationError when the endpoint returned 404 and the field
  // was never assigned. Now nullable, with a defensive fallback below.
  CardChargesModel? _cardChargesModel;

  /// Legacy non-null getter. Returns a zero-filled fallback model when the
  /// API hasn't populated state yet so existing call sites that read
  /// `controller.cardChargesModel.data.cardCharge.X` keep rendering zeros
  /// instead of crashing.
  CardChargesModel get cardChargesModel =>
      _cardChargesModel ?? _emptyChargesModel;

  static final CardChargesModel _emptyChargesModel = CardChargesModel(
    message: ccm.Message(success: const []),
    data: ccm.Data(
      baseCurr: 'USD',
      cardCharge: ccm.CardCharge(
        id: 0,
        slug: '',
        title: '',
        fixedCharge: 0,
        percentCharge: 0,
        minLimit: 0,
        maxLimit: 0,
      ),
    ),
  );

  // ── Convenience getters for the redesigned create-card flow ──────────
  // The CardChargesModel only exposes per-transaction limits + fee/percent,
  // not daily/monthly limits — those live on FlutterWaveCardController and
  // are read directly from there in the UI.
  String get currency => _cardChargesModel?.data.baseCurr ?? 'USD';

  double get fixedChargeValue =>
      (_cardChargesModel?.data.cardCharge.fixedCharge ?? 0).toDouble();

  double get percentChargeValue =>
      (_cardChargesModel?.data.cardCharge.percentCharge ?? 0).toDouble();

  double get minTransaction =>
      (_cardChargesModel?.data.cardCharge.minLimit ?? 0).toDouble();

  double get maxTransaction =>
      (_cardChargesModel?.data.cardCharge.maxLimit ?? 0).toDouble();

  Future<void> _getCardChargesData() async {
    _isLoading.value = true;
    chargesUnavailable.value = false;
    update();

    await ApiServices.cardChargesApi().then((value) {
      if (value != null) {
        _cardChargesModel = value;
      } else {
        // API returned null body / non-200. Keep the model null and surface
        // the warning state so the UI can show a notice instead of crashing.
        chargesUnavailable.value = true;
      }
      update();
    }).catchError((onError) {
      log.e(onError);
      chargesUnavailable.value = true;
      _isLoading.value = false;
      update();
    });

    _isLoading.value = false;
    update();
  }

  // Public trigger for refetch.
  get getCardChargesData => _getCardChargesData();
}
