import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import "package:TAKARA PAY/base/api/model/add_money/add_money_info_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/authorize_confirm_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/authorize_submit_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_bkash_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_flutterwave.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_paypal_getway.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_razorpay_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_ssclcommerz_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/automatic_stripe_getway_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/common_payment_model.dart";
import "package:TAKARA PAY/base/api/model/add_money/tatum/tatum_insert_model.dart";
import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/routes/routes.dart";
import "package:TAKARA PAY/base/utils/dimensions.dart";
import "package:TAKARA PAY/base/utils/size.dart";
import "package:TAKARA PAY/views/deposit/screen/authorize_screen.dart";
import "package:TAKARA PAY/views/deposit/screen/automatic_web_view_screen.dart";
import "package:TAKARA PAY/base/widgets/inputs/primary_input_filed.dart";
import "package:TAKARA PAY/base/widgets/others/congratulation_widget.dart";
import "package:TAKARA PAY/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:TAKARA PAY/views/deposit/controller/manual_gateway_controller.dart";

class DepositController extends GetxController {
  final remainingController = Get.put(RemainingBalanceController());

  final amountController = TextEditingController();
  final depositMethod = TextEditingController();

  final cardNumberController = TextEditingController();
  final cardExpiryController = TextEditingController();
  final cardCVCController = TextEditingController();

  final cardHolderNameController = TextEditingController();
  final cardExpiryDateController = TextEditingController();
  final cardCvvController = TextEditingController();
  final identifier = "".obs;

  final flipCardController = FlipCardController();
  RxDouble amount = 0.0.obs;
  RxString baseCurrency = "".obs;
  RxDouble baseCurrencyRate = 1.0.obs;
  RxString selectedCurrencyAlias = "".obs;
  RxString selectedCurrencyName = "Select Method".obs;
  RxString selectedCurrencyType = "".obs;
  RxString selectedGatewaySlug = "".obs;
  RxString gatewayTrx = "".obs;
  RxInt selectedCurrencyId = 0.obs;
  RxDouble selectedFee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble minLimCal = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble maxLimCal = 0.0.obs;
  RxDouble dallyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble getRemainingMonthLyLimit = 0.0.obs;
  RxDouble getRemainingDailyLimit = 0.0.obs;

  RxDouble percentCharge = 0.0.obs;
  RxDouble supportedRate = 0.0.obs;
  RxString code = "".obs;
  RxInt crypto = 0.obs;
  List<int> indexList = [];
  List<Currency> currencyList = [];

  //tatum
  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  List<String> listFieldName = [];
  RxList inputFileFields = [].obs;
  RxString qrAddress = ''.obs;
  RxString paymentURl = "".obs;
  RxString appBarName = "".obs;
  final manualPaymentController = Get.put(ManualPaymentController());

  @override
  void onInit() {
    getAddMoneyInfo();
    super.onInit();
  }

  @override
  void onClose() {
    amountController.dispose();
    depositMethod.dispose();
    cardNumberController.dispose();
    cardExpiryController.dispose();
    cardCVCController.dispose();
    cardHolderNameController.dispose();
    cardExpiryDateController.dispose();
    cardCvvController.dispose();
    for (final controller in inputFieldControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  // List.clear() drops the references without disposing them — dispose each
  // controller first so re-fetching the dynamic fields doesn't leak the old
  // ones.
  void _disposeAndClearInputFieldControllers() {
    for (final controller in inputFieldControllers) {
      controller.dispose();
    }
    inputFieldControllers.clear();
  }

  late AddMoneyInfoModel _addMoneyInfoModel;

  AddMoneyInfoModel get addMoneyInfoModel => _addMoneyInfoModel;

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  final _isPaypalLoading = false.obs;

  bool get isPaypalLoading => _isPaypalLoading.value;
  final _isInsertLoading = false.obs;

  bool get isStripeLoading => _isInsertLoading.value;

  Future<AddMoneyInfoModel> getAddMoneyInfo() async {
    _isLoading.value = true;
    update();

    await ApiServices.addMoneyInfoApi()
        .then((value) {
          _addMoneyInfoModel = value!;
          _addMoneyInfoModel.data.gateways.forEach((gateways) {
            gateways.currencies.forEach((currency) {
              currencyList.add(
                Currency(
                  id: currency.id,
                  paymentGatewayId: currency.paymentGatewayId,
                  name: currency.name,
                  alias: currency.alias,
                  currencyCode: currency.currencyCode,
                  currencySymbol: currency.currencySymbol,
                  minLimit: currency.minLimit,
                  maxLimit: currency.maxLimit,
                  percentCharge: currency.percentCharge,
                  fixedCharge: currency.fixedCharge,
                  rate: currency.rate,
                  createdAt: currency.createdAt,
                  updatedAt: currency.updatedAt,
                  type: currency.type,
                  image: currency.image,
                  monthlyLimit: currency.monthlyLimit,
                  dailyLimit: currency.dailyLimit,
                  crypto: currency.crypto,
                ),
              );
            });
          });
          Currency currency =
              _addMoneyInfoModel.data.gateways.first.currencies.first;
          Gateway gateway = _addMoneyInfoModel.data.gateways.first;

          selectedCurrencyAlias.value = currency.alias;
          selectedCurrencyType.value = currency.type.toString();
          selectedGatewaySlug.value = gateway.slug.toString();
          selectedCurrencyId.value = currency.id;
          // selectedCurrencyName.value = currency.name;
          supportedRate.value = currency.rate;

          selectedFee.value = currency.fixedCharge.toDouble();
          limitMin.value = currency.minLimit;
          limitMax.value = currency.maxLimit.toDouble();
          dallyLimit.value = currency.dailyLimit.toDouble();
          monthlyLimit.value = currency.monthlyLimit.toDouble();
          percentCharge.value = currency.percentCharge.toDouble();
          supportedRate.value = currency.rate;
          code.value = currency.currencyCode;

          // Get remaining limit
          remainingController.transactionType.value =
              _addMoneyInfoModel.data.getRemainingFields.transactionType;
          remainingController.attribute.value =
              _addMoneyInfoModel.data.getRemainingFields.attribute;
          remainingController.cardId.value =
              _addMoneyInfoModel.data.gateways.first.currencies.first.id;
          remainingController.senderAmount.value = amountController.text.isEmpty
              ? '0.00'
              : amountController.text;
          remainingController.senderCurrency.value = _addMoneyInfoModel
              .data
              .gateways
              .first
              .currencies
              .first
              .currencyCode;
          limitCalculation();
          remainingController.getRemainingBalanceProcess();

          //Base Currency
          baseCurrency.value = _addMoneyInfoModel.data.baseCurr;
          baseCurrencyRate.value = _addMoneyInfoModel.data.baseCurrRate
              .toDouble();

          update();
        })
        .catchError((onError) {
          log.e(onError);
          _isLoading.value = false;
          update();
        });

    _isLoading.value = false;
    update();
    return _addMoneyInfoModel;
  }

  void limitCalculation() {
    dallyLimit.value = dallyLimit.value / supportedRate.value;
    monthlyLimit.value = monthlyLimit.value / supportedRate.value;
    getRemainingDailyLimit.value =
        remainingController.remainingDailyLimit.value;
    getRemainingMonthLyLimit.value =
        remainingController.remainingMonthLyLimit.value;

    minLimCal.value = limitMin.value / supportedRate.value;

    maxLimCal.value = limitMax.value / supportedRate.value;
  }

  late AutomaticPaymentPaypalGatewayModel _automaticPaymentPaypalGatewayModel;

  AutomaticPaymentPaypalGatewayModel get automaticPaymentPaypalGatewayModel =>
      _automaticPaymentPaypalGatewayModel;

  Future<AutomaticPaymentPaypalGatewayModel>
  automaticPaymentPaypalGatewaysProcess(inputBody) async {
    _isPaypalLoading.value = true;
    update();
    await ApiServices.automaticPaymentPaypalGatewayApi(body: inputBody)
        .then((value) {
          _automaticPaymentPaypalGatewayModel = value!;
          update();
          Get.toNamed(Routes.webPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isPaypalLoading.value = false;
        });

    _isPaypalLoading.value = false;

    update();
    return _automaticPaymentPaypalGatewayModel;
  }

  // Automatic Payment Stripe Gateway Model
  late AutomaticPaymentStripeGatewayModel _automaticPaymentStripeGatewayModel;

  AutomaticPaymentStripeGatewayModel get automaticPaymentStripeGatewayModel =>
      _automaticPaymentStripeGatewayModel;

  Future<AutomaticPaymentStripeGatewayModel>
  automaticPaymentStripeGatewaysProcess(inputBody) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticPaymentStripeGatewayApi(body: inputBody)
        .then((value) {
          _automaticPaymentStripeGatewayModel = value!;

          update();

          Get.toNamed(Routes.stripeWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticPaymentStripeGatewayModel;
  }

  //! Automatic sslcommerz Model
  late AutomaticPaymentSslcommerzModel _automaticPaymentSslcommerzModel;

  AutomaticPaymentSslcommerzModel get automaticPaymentSslcommerzModel =>
      _automaticPaymentSslcommerzModel;

  Future<AutomaticPaymentSslcommerzModel> automaticSslCommerzProcess(
    inputBody,
  ) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticSslcommerzApi(body: inputBody)
        .then((value) {
          _automaticPaymentSslcommerzModel = value!;

          update();

          Get.toNamed(Routes.sslCommerzWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticPaymentSslcommerzModel;
  }

  late AutomaticBkashModel _automaticBkashModel;

  AutomaticBkashModel get automaticBkashModel => _automaticBkashModel;

  Future<AutomaticBkashModel> automaticSslBkashProcess(inputBody) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticBkashAPi(body: inputBody)
        .then((value) {
          _automaticBkashModel = value!;
          update();

          Get.toNamed(Routes.sslCommerzWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticBkashModel;
  }

  //! Automatic flutterwave Model
  late AutomaticPaymentFlutterwaveModel _automaticPaymentFlutterwaveModel;

  AutomaticPaymentFlutterwaveModel get automaticPaymentFlutterwaveModel =>
      _automaticPaymentFlutterwaveModel;

  Future<AutomaticPaymentFlutterwaveModel> automaticFlutterwaveProcess(
    inputBody,
  ) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticFlutterwaveApi(body: inputBody)
        .then((value) {
          _automaticPaymentFlutterwaveModel = value!;

          update();

          Get.toNamed(Routes.flutterWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticPaymentFlutterwaveModel;
  }

  //! Automatic razorpay Model
  late AutomaticPaymentRazorpayModel _automaticPaymentRazorpayModel;

  AutomaticPaymentRazorpayModel get automaticPaymentRazorpayModel =>
      _automaticPaymentRazorpayModel;

  Future<AutomaticPaymentRazorpayModel> automaticRazorpayProcess(
    inputBody,
  ) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticRazorpayApi(body: inputBody)
        .then((value) {
          _automaticPaymentRazorpayModel = value!;

          update();

          Get.toNamed(Routes.razorPayWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticPaymentRazorpayModel;
  }

  //! Automatic razorpay Model
  late AutomaticPaymentRazorpayModel _automaticPaymentQrpay;

  AutomaticPaymentRazorpayModel get automaticPaymentQrpay =>
      _automaticPaymentQrpay;

  Future<AutomaticPaymentRazorpayModel> automaticQrpayProcess(inputBody) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticQrpayApi(body: inputBody)
        .then((value) {
          _automaticPaymentQrpay = value!;

          update();

          Get.toNamed(Routes.qrPayWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });

    _isInsertLoading.value = false;

    update();
    return _automaticPaymentQrpay;
  }

  //! Automatic Process
  late AutomaticPaymentRazorpayModel _automaticPayment;

  AutomaticPaymentRazorpayModel get automaticPayment => _automaticPayment;

  Future<AutomaticPaymentRazorpayModel> automaticProcess(inputBody) async {
    _isInsertLoading.value = true;
    update();

    await ApiServices.automaticQrpayApi(body: inputBody)
        .then((value) {
          _automaticPayment = value!;

          update();

          Get.to(
            () => AutomaticWebViewScreen(
              title: _automaticPayment.data.gatewayCurrencyName,
              paymentUrl: _automaticPayment.data.url,
            ),
          );
        })
        .catchError((onError) {
          log.e(onError);
          _isInsertLoading.value = false;
        });
    _isInsertLoading.value = false;
    update();
    return _automaticPayment;
  }

  //! coin gate
  late CommonPaymentsModel _coinGateModel;

  CommonPaymentsModel get coinGateModel => _coinGateModel;

  // add money coin gate
  Future<CommonPaymentsModel> coinGateProcess() async {
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountController.text,
      'currency': selectedCurrencyAlias.value,
      'source': 'APP',
    };

    await ApiServices.coinGateInsertApi(body: inputBody)
        .then((value) {
          _coinGateModel = value!;

          update();
          Get.toNamed(Routes.coinWebPaymentScreen);
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isInsertLoading.value = false;
    update();
    return _coinGateModel;
  }

  //! Tatum payment gateway
  late TatumGatewayModel _tatumGatewayModel;

  TatumGatewayModel get tatumGatewayModel => _tatumGatewayModel;

  // add money coin gate
  Future<TatumGatewayModel> tatumProcess() async {
    inputFields.clear();
    _disposeAndClearInputFieldControllers();
    _isInsertLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'amount': amountController.text,
      'currency': selectedCurrencyAlias.value,
      'source': 'APP',
    };

    await ApiServices.tatumInsertApi(body: inputBody)
        .then((value) {
          _tatumGatewayModel = value!;

          final data =
              _tatumGatewayModel.data.gatewayInfo.addressInfo.inputFields;
          qrAddress.value =
              _tatumGatewayModel.data.gatewayInfo.addressInfo.address;
          for (int item = 0; item < data.length; item++) {
            // make the dynamic controller
            var textEditingController = TextEditingController();
            inputFieldControllers.add(textEditingController);

            if (data[item].type.contains('text')) {
              inputFields.add(
                Column(
                  children: [
                    PrimaryInputWidget(
                      paddings: EdgeInsets.only(
                        left: Dimensions.widthSize,
                        right: Dimensions.widthSize,
                        top: Dimensions.heightSize * 0.5,
                      ),
                      controller: inputFieldControllers[item],
                      hint: data[item].label,
                      isValidator: data[item].required,
                      label: data[item].label,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          int.parse(data[item].validation.max.toString()),
                        ),
                      ],
                    ),
                    verticalSpace(Dimensions.heightSize),
                  ],
                ),
              );
            }
          }
          Get.toNamed(Routes.tatumPaymentScreen);
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isInsertLoading.value = false;
    update();
    return _tatumGatewayModel;
  }

  final _isTatumConfirmLoading = false.obs;

  bool get isTatumConfirmLoading => _isTatumConfirmLoading.value;
  late CommonSuccessModel _addMoneyConfirm;

  CommonSuccessModel get addMoneyConfirm => _addMoneyConfirm;

  // Profile TatumConfirm process with image
  Future<CommonSuccessModel> tatumConfirmProcess(context) async {
    _isTatumConfirmLoading.value = true;
    update();

    Map<String, String> inputBody = {};
    final data = _tatumGatewayModel.data.gatewayInfo.addressInfo.inputFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await ApiServices.tatumConfirmApiProcess(
          body: inputBody,
          url: _tatumGatewayModel.data.gatewayInfo.addressInfo.submitUrl,
        )
        .then((value) {
          _addMoneyConfirm = value!;
          _goToSuccessScreen(context);
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isTatumConfirmLoading.value = false;
    update();
    return _addMoneyConfirm;
  }

  ///>>>> add money qrpay
  late AddMoneyAuthorizeModel _addMoneyAuthorizeModel;

  AddMoneyAuthorizeModel get addMoneyAuthorizeModel => _addMoneyAuthorizeModel;

  Future<AddMoneyAuthorizeModel> authorizeSubmitProcess() async {
    _isPaypalLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'amount': amountController.text,
      'currency': selectedCurrencyAlias.value,
      'source': 'APP',
    };
    await ApiServices.addMoneyAuthorizeApi(body: inputBody)
        .then((value) {
          _addMoneyAuthorizeModel = value!;
          update();

          identifier.value = _addMoneyAuthorizeModel.data.tempToken;

          Get.toNamed(Routes.depositPreviewScreen);
        })
        .catchError((onError) {
          log.e(onError);
          _isPaypalLoading.value = false;
        });

    _isPaypalLoading.value = false;

    update();
    return _addMoneyAuthorizeModel;
  }

  ///* Automatic Authorize Process Api process start
  final _isAuthorizeConfirmLoading = false.obs;
  bool get isAuthorizeConfirmLoading => _isAuthorizeConfirmLoading.value;
  late AuthorizeConfirmModel _automaticAuthorizeModel;
  AuthorizeConfirmModel get automaticAuthorizeModel => _automaticAuthorizeModel;

  Future<AuthorizeConfirmModel> automaticAuthorizeProcessApi(
    BuildContext context,
  ) async {
    _isAuthorizeConfirmLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'identifier': identifier.value,
      'card_number': cardNumberController.text,
      'date': cardExpiryController.text,
      'code': cardCVCController.text,
    };

    await ApiServices.automaticAuthorizeProcess(body: inputBody)
        .then((value) {
          _automaticAuthorizeModel = value!;
          // LocalStorages.saveTrackingTrx(
          //   trx: _automaticAuthorizeModel.data.transactionTrx,
          // );
          // pdfTrxString.value = _automaticAuthorizeModel.data.transactionTrx;
          // Get.toNamed(Routes.goToCongratulationScreen);
          // Get.put(DepositController()).goToDashboardScreen(context);
          StatusScreen.show(
            context: context,
            subTitle: Strings.yourMoneyAddedSucces.tr,
            onPressed: () {
              Get.offAllNamed(Routes.bottomNavBarScreen);
            },
          );
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isAuthorizeConfirmLoading.value = false;
    update();
    return _automaticAuthorizeModel;
  }

  void _goToSuccessScreen(context) {
    StatusScreen.show(
      context: context,
      subTitle: Strings.yourMoneyAddedSucces.tr,
      onPressed: () {
        Get.offAllNamed(Routes.bottomNavBarScreen);
      },
    );
  }

  paymentProceed() {
    Map<String, dynamic> inputBody = {
      'amount': double.parse(amountController.text),
      'currency': selectedCurrencyAlias.value,
      'source': 'APP',
    };
    switch (selectedCurrencyType.value) {
      case "Type.AUTOMATIC":
        {
          if (selectedCurrencyAlias.contains('stripe')) {
            automaticPaymentStripeGatewaysProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('paypal')) {
            automaticPaymentPaypalGatewaysProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('sslcommerz')) {
            automaticSslCommerzProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('flutterwave')) {
            automaticFlutterwaveProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('razorpay')) {
            automaticRazorpayProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('qrpay')) {
            automaticQrpayProcess(inputBody);
          } else if (selectedCurrencyAlias.contains('coingate')) {
            coinGateProcess();
          } else if (selectedCurrencyAlias.contains('tatum')) {
            tatumProcess();
          } else if (selectedCurrencyAlias.contains('authorize')) {
            Get.to(AuthorizeGatewayScreen());
          } else {
            automaticProcess(inputBody);
          }
        }
        break;
      case "Type.MANUAL":
        {
          manualPaymentController.manualPaymentGatewaysProcess(inputBody);
        }
        break;
    }
  }
}
