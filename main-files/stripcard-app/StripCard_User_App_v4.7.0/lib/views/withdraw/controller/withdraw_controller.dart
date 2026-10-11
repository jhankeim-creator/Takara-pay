import 'package:flutter/services.dart';
import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/views/remaining_balance/controller/remaing_balance_controller.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/withdraw/dynamic_input_withdraw_model.dart";
import "package:stripcard/base/api/model/withdraw/withdraw_info_model.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/inputs/primary_input_filed.dart";
import "package:stripcard/base/widgets/design_system/sc_success_screen.dart";
import "package:stripcard/base/widgets/others/manual_payment_image_widget.dart";

class MoneyOutController extends GetxController {
  final remainingController = Get.put(RemainingBalanceController());
  final moneyOutAmountTextController = TextEditingController();
  RxString selectedCurrencyAlias = "".obs;
  RxString selectedCurrencyName = "".obs;
  RxDouble amount = 0.00.obs;
  RxString baseCurrency = "".obs;
  RxDouble fixesCharge = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble dallyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  RxBool hasFile = false.obs;
  List<Currency> allCurrencyList = [];
  RxString selectAlias = "".obs;
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  RxDouble requestAmount = 0.00.obs;
  RxDouble totalCharge = 0.00.obs;
  RxDouble youWillGet = 0.00.obs;
  RxDouble exchangeRate = 0.00.obs;
  RxDouble payableAmount = 0.00.obs;
  
  List<String> totalAmount = [];

  @override
  void onClose() {
    moneyOutAmountTextController.dispose();
    for (var controller in inputFieldControllers) {
      controller.dispose();
    }

    super.onClose();
  }

  @override
  void onInit() {
    getMoneyOutData();

    super.onInit();
  }

  // get wallet
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // Was `late WithdrawInfoModel _withdrawInfoModel;` — that crashed with
  // LateInitializationError whenever the API call errored (no assignment
  // ever happened, but the `return _withdrawInfoModel;` at end of method
  // was reached). Now nullable so the read sites can guard.
  WithdrawInfoModel? _withdrawInfoModel;

  WithdrawInfoModel? get withdrawInfoModel => _withdrawInfoModel;
  bool get hasWithdrawInfoData => _withdrawInfoModel != null;

  Future<WithdrawInfoModel?> getMoneyOutData() async {
    _isLoading.value = true;
    update();
    await ApiServices.withdrawInfoApi()
        .then((value) {
          _withdrawInfoModel = value!;
          final fresh = _withdrawInfoModel!;

          for (var gateways in fresh.data.gateways) {
            for (var currency in gateways.currencies) {
              allCurrencyList.add(
                Currency(
                  createdAt: currency.createdAt,
                  updatedAt: currency.updatedAt,
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
                  type: currency.type,
                  image: currency.image,
                  dailyLimit: currency.dailyLimit,
                  monthlyLimit: currency.monthlyLimit,
                ),
              );
            }
            baseCurrency.value = fresh.data.baseCurr;
            Currency currency =
                fresh.data.gateways.first.currencies.first;
            selectedCurrencyName.value = currency.name;
            selectAlias.value = currency.alias;
            limitMin.value = currency.minLimit.toDouble();
            limitMax.value = currency.maxLimit.toDouble();
            monthlyLimit.value = currency.monthlyLimit.toDouble();
            dallyLimit.value = currency.dailyLimit.toDouble();

            fixesCharge.value = currency.fixedCharge.toDouble();
          }

          _isLoading.value = false;

          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _withdrawInfoModel;
  }

  goToMoneyOutPreviewScreen() {
    Get.toNamed(Routes.moneyOutPreviewScreen);
  }

  final _isInsertLoading = false.obs;

  bool get isInsertLoading => _isInsertLoading.value;

  //money out insert process

  // Was `late DynamicInputWithdrawModel _moneyOutInsertModel;` — same
  // LateInitializationError pattern. Backend can return 400 (e.g.
  // "Please follow the transaction limit") and the success-only assignment
  // never fires; subsequent reads in confirmProcess + the manual-payment
  // screen crash. Now nullable with a guard.
  DynamicInputWithdrawModel? _moneyOutInsertModel;

  DynamicInputWithdrawModel? get moneyOutInsertModel => _moneyOutInsertModel;
  bool get hasMoneyOutInsertData => _moneyOutInsertModel != null;

  ///* A -dd Money manual insert api process start
  Future<DynamicInputWithdrawModel?> manualPaymentGetGatewaysProcess() async {
    _isInsertLoading.value = true;
    inputFields.clear();
    listImagePath.clear();
    listFieldName.clear();
    inputFieldControllers.clear();
    update();

    Map<String, dynamic> inputBody = {
      'amount': moneyOutAmountTextController.text,
      'gateway': selectAlias.value,
    };

    await ApiServices.withdrawInsertApi(body: inputBody)
        .then((value) {
          _moneyOutInsertModel = value!;
          final fresh = _moneyOutInsertModel!;

          requestAmount.value =
              double.tryParse(
                fresh.data.paymentInformations.requestAmount,
              ) ??
              0.0;
          totalCharge.value =
              double.tryParse(
                fresh.data.paymentInformations.totalCharge,
              ) ??
              0.0;
          youWillGet.value =
              double.tryParse(
                fresh.data.paymentInformations.willGet,
              ) ??
              0.0;
          exchangeRate.value =
              double.tryParse(
                fresh.data.paymentInformations.exchangeRate,
              ) ??
              0.0;
          payableAmount.value =
              double.tryParse(
                fresh.data.paymentInformations.payable,
              ) ??
              0.0;

          ///* Add money manual insert api process start
          final data = fresh.data.inputFields;

          for (int item = 0; item < data.length; item++) {
            // make the dynamic controller
            var textEditingController = TextEditingController();
            inputFieldControllers.add(textEditingController);

            // make dynamic input widget
            if (data[item].type.contains('file')) {
              hasFile.value = true;
              inputFields.add(
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: crossStart,
                      children: [
                        Text(
                          Strings.screenshot,
                          style: CustomStyle.darkHeading4TextStyle.copyWith(
                            fontWeight: FontWeight.w600,
                            color: CustomColor.primaryLightTextColor,
                          ),
                        ),
                        verticalSpace(Dimensions.heightSize * .8),
                        ManualPaymentImageWidget(
                          labelName: data[item].label,
                          fieldName: data[item].name,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (data[item].type.contains('text') ||
                data[item].type.contains('textarea')) {
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
                    verticalSpace(Dimensions.heightSize * 0.5),
                  ],
                ),
              );
            }
          }

          //-------------------------- Process inputs end --------------------------
          Get.toNamed(Routes.moneyOutManualPaymentScreen);
          _isInsertLoading.value = false;

          update();
        })
        .catchError((onError) {
          _isInsertLoading.value = false;
          log.e(onError);
        });

    update();
    return _moneyOutInsertModel;
  }

  final _isConfirmLoading = false.obs;

  bool get isConfirmLoading => _isConfirmLoading.value;

  //! ---------------------------- Add Money Manual Payment Process -------------------------

  // Was `late CommonSuccessModel _manualPaymentConfirmModel;` — same
  // LateInitializationError pattern when the submit API errors out (e.g.
  // backend rejects an invalid card number with 400).
  CommonSuccessModel? _manualPaymentConfirmModel;

  CommonSuccessModel? get manualPaymentConfirmModel =>
      _manualPaymentConfirmModel;
  bool get hasManualPaymentConfirmData => _manualPaymentConfirmModel != null;

  Future<CommonSuccessModel?> confirmProcess(context) async {
    // Guard the pre-API reads below — if the user reached this method
    // with an empty insert model (stale state, hot-reload, etc.) we'd
    // crash on the very first line of the body.
    final insert = _moneyOutInsertModel;
    if (insert == null) {
      _isConfirmLoading.value = false;
      update();
      return null;
    }

    _isConfirmLoading.value = true;
    Map<String, String> inputBody = {
      'trx': insert.data.paymentInformations.trx,
    };

    final data = insert.data.inputFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await ApiServices.withdrawSubmitApi(
          body: inputBody,
          fieldList: listFieldName,
          pathList: listImagePath,
        )
        .then((value) {
          _manualPaymentConfirmModel = value!;
          _goToSuccessScreen(context);

          _isConfirmLoading.value = false;
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });
    _isConfirmLoading.value = false;
    update();
    return _manualPaymentConfirmModel;
  }

  void _goToSuccessScreen(context) {
    final amount =
        double.tryParse(moneyOutAmountTextController.text) ?? 0;
    final gatewayName = selectedCurrencyName.value.isEmpty
        ? 'Bank transfer'
        : selectedCurrencyName.value;
    final trx = _moneyOutInsertModel?.data.paymentInformations.trx ?? '';
    // totalCharge and youWillGet are RxDoubles populated from
    // _moneyOutInsertModel.data.paymentInformations during the insert step.
    final fee = totalCharge.value;
    final receive = youWillGet.value > 0 ? youWillGet.value : amount - fee;

    Get.offAll(
      () => SCSuccessScreen(
        title: 'Withdrawal sent',
        subtitle: '\$${amount.toStringAsFixed(2)} to $gatewayName',
        details: [
          if (trx.isNotEmpty)
            SCSuccessDetail(
              label: 'Reference',
              value: trx,
              isMono: true,
              copyable: true,
            ),
          const SCSuccessDetail(
            label: 'Arrives',
            value: '1-3 business days',
          ),
          SCSuccessDetail(
            label: 'Amount',
            value: '\$${amount.toStringAsFixed(2)}',
            isMono: true,
          ),
          SCSuccessDetail(
            label: 'Fee',
            value: '\$${fee.toStringAsFixed(2)}',
            isMono: true,
          ),
          SCSuccessDetail(
            label: 'Receive',
            value: '\$${receive.toStringAsFixed(2)}',
            isMono: true,
          ),
        ],
        activityRoute: Routes.transactionLogScreen,
      ),
    );
  }
}
