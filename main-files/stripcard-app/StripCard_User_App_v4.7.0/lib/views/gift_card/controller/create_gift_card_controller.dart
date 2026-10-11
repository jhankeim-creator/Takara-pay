import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/gift_card/gift_details_model.dart";
import "package:stripcard/base/api/services/gift_card_api_services.dart";
import "package:stripcard/base/api/method/api_method.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/views/gift_card/controller/gift_card_controller.dart";

class CreateGiftCardController extends GetxController {
  final controller = Get.put(GiftCardController());
  // Same singleton the preview/details screens read for the remaining-limit
  // display. Populated once details load (see getGiftCardDetailsInfo).
  final remainingController = Get.put(RemainingBalanceController());
  final receiverEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final fromNameController = TextEditingController();
  final quantityController = TextEditingController();
  final amountController = TextEditingController();

  RxString selectedWalletName = ''.obs;
  RxString selectedWalletCurrency = ''.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedCountryCode = ''.obs;
  RxString mobileCode = ''.obs;
  RxString selectedAmount = ''.obs;
  RxInt selectedIndex = 0.obs;
  RxDouble exRate = 0.00.obs;

  RxDouble totalCharge = 0.00.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
  RxDouble FixedCharge = 0.00.obs;

  RxDouble limitMin = 0.00.obs;
  RxDouble limitMax = 0.00.obs;
  RxDouble dailyLimit = 0.00.obs;
  RxDouble monthlyLimit = 0.00.obs;

  final List<CountryElement> countryList = [];
  final List<UserWallet> userWalletList = [];

  @override
  void onInit() {
    getGiftCardDetailsInfo();
    super.onInit();
  }

  @override
  void onClose() {
    receiverEmailController.dispose();
    phoneNumberController.dispose();
    fromNameController.dispose();
    quantityController.dispose();
    amountController.dispose();
    super.onClose();
  }




  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // True only once the details model has been fetched + parsed successfully.
  // The screen gates its body on this so it never reads the uninitialised
  // `late _giftCardDetailsModel` (which would throw LateInitializationError).
  final _isLoaded = false.obs;

  bool get isLoaded => _isLoaded.value;

  final _isBuyLoading = false.obs;

  bool get isBuyLoading => _isBuyLoading.value;

  late GiftCardDetailsModel _giftCardDetailsModel;

  GiftCardDetailsModel get giftCardDetailsModel => _giftCardDetailsModel;

  Future<GiftCardDetailsModel> getGiftCardDetailsInfo() async {
    _isLoading.value = true;
    update();
    await GiftCardApiServices.getGiftCardDetailsApi(LocalStorage.getProductId())
        .then((value) {
      _giftCardDetailsModel = value!;
      _isLoaded.value = true;
      selectedCountry.value =
          _giftCardDetailsModel.data.countries.first.currencyName;
      exRate.value = _giftCardDetailsModel.data.userWallet.first.rate;
      FixedCharge.value = _giftCardDetailsModel.data.userWallet.first.fCharge;
      selectedCountryCode.value =
          _giftCardDetailsModel.data.countries.first.iso2;
      mobileCode.value = _giftCardDetailsModel.data.countries.first.mobileCode;
      limitMin.value =
          double.parse(_giftCardDetailsModel.data.cardCharge.minLimit);
      limitMax.value =
          double.parse(_giftCardDetailsModel.data.cardCharge.maxLimit);
      dailyLimit.value =
          double.parse(_giftCardDetailsModel.data.cardCharge.dailyLimit);
      monthlyLimit.value =
          double.parse(_giftCardDetailsModel.data.cardCharge.monthlyLimit);

      // Fetch the user's remaining daily/monthly gift-card allowance so the
      // "App Limit Information" card shows real figures instead of 0.0000.
      remainingController.transactionType.value = 'GIFT-CARD';
      remainingController.attribute.value = 'SEND';
      remainingController.senderAmount.value = '1';
      remainingController.senderCurrency.value =
          LocalStorage.getBaseCurrency() ?? 'USD';
      remainingController.cardId.value =
          _giftCardDetailsModel.data.cardCharge.id;
      remainingController.getRemainingBalanceProcess();
      for (var element in _giftCardDetailsModel.data.countries) {
        countryList.add(
          CountryElement(
            name: element.name,
            mobileCode: element.mobileCode,
            currencyName: element.currencyName,
            currencyCode: element.currencyCode,
            currencySymbol: element.currencySymbol,
            iso2: element.iso2,
          ),
        );
      }

      /// User Wallet
      selectedWalletName.value =
          _giftCardDetailsModel.data.userWallet.first.name;
      selectedWalletCurrency.value =
          _giftCardDetailsModel.data.userWallet.first.currencyCode;
      for (var element in _giftCardDetailsModel.data.userWallet) {
        userWalletList.add(
          UserWallet(
            name: element.name,
            balance: element.balance,
            currencyCode: element.currencyCode,
            currencySymbol: element.currencySymbol,
            currencyType: element.currencyType,
            flag: element.flag,
            imagePath: element.imagePath,
            rate: element.rate,
          ),
        );
      }
      update();
    }).catchError((onError) {
      log.e(onError);
    });
    _isLoading.value = false;
    update();
    return _giftCardDetailsModel;
  }


  void calculation() {
    CardCharge data = _giftCardDetailsModel.data.cardCharge;

    // Safely parse amountController.text
    double amount = double.tryParse(amountController.text) ?? 0.0;

    // Parse percentCharge safely
    double percent = double.tryParse(data.percentCharge) ?? 0.0;

    // Calculate percentCharge
    percentCharge.value = (amount / 100) * percent;

    // Calculate totalCharge safely
    double fixedCharge = double.tryParse(data.fixedCharge.toString()) ?? 0.0;
    totalCharge.value = (fixedCharge * exRate.value) + percentCharge.value;

    // Calculate totalPay
    totalPay.value = amount + totalCharge.value;
  }

  CommonSuccessModel? _successModel;

  CommonSuccessModel? get successModel => _successModel;

  Future<CommonSuccessModel?> createGiftCardApi() async {
    // Guard against duplicate orders: the preview's Buy Now button could be
    // tapped repeatedly before the loader showed (it was toggling the wrong
    // flag), firing the order API multiple times → multiple gift-card orders.
    if (_isBuyLoading.value) return _successModel;
    _isBuyLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'product_id': LocalStorage.getProductId(),
      'amount': giftCardDetailsModel
          .data.product.fixedRecipientDenominations[selectedIndex.value],
      'receiver_email': receiverEmailController.text,
      'receiver_country': selectedCountryCode.value,
      'receiver_phone_code': mobileCode.value,
      'receiver_phone': phoneNumberController.text,
      'from_name': fromNameController.text,
      'quantity': quantityController.text,
      'wallet_currency': selectedWalletCurrency.value,
    };

    await GiftCardApiServices.createGiftCardApi(body: inputBody).then((value) {
      _successModel = value;
      controller.getMyCardInfoApi();
      // Replace the preview so it can't be revisited and re-submitted.
      Get.offNamed(Routes.giftCardScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isBuyLoading.value = false;
    update();

    return _successModel;
  }
}
