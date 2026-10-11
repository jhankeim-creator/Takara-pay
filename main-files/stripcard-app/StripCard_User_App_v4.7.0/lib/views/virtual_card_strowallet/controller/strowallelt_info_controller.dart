import 'package:intl/intl.dart';

import "package:stripcard/base/api/services/api_services.dart";
import "package:stripcard/base/api/model/common/common_success_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/createcard_strowallet_info_model.dart";
import "package:stripcard/base/api/model/virtual_card/strowallet_models/strowallet_card_model.dart";
import "package:stripcard/base/utils/local_storage.dart";
import "package:stripcard/base/api/services/strowallet_api_services.dart";
import "package:stripcard/base/api/endpoint/api_endpoint.dart";
import "package:stripcard/base/utils/request_process.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/inputs/image_widget.dart";
import "package:stripcard/base/widgets/inputs/number_input-widget.dart";
import "package:stripcard/base/widgets/inputs/primary_input_filed.dart";
import "package:stripcard/base/widgets/others/congratulation_widget.dart";
import "package:stripcard/views/navbar/controller/dashboard_controller.dart";
import "package:stripcard/views/profile/controller/update_profile_controller.dart";

class VirtualStrowalletCardController extends GetxController {
  final dashboardController = Get.put(DashBoardController());
  final updateProfileController = Get.put(UpdateProfileController());

  final fundAmountController = TextEditingController();

  final firstNameController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final houseNumberController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final lineController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final idTypeController = TextEditingController();

  RxString strowalletCardId = "".obs;
  RxInt activeIndicatorIndex = 0.obs;

  RxDouble totalCharge = 0.00.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
  // RxDouble amount = 0.00.obs;

  //
  List<TextEditingController> inputFieldControllers = [];
  RxList inputFields = [].obs;
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  RxBool hasFile = false.obs;
  RxString appBarTitle = "".obs;
  //

  @override
  void onClose() {
    fundAmountController.dispose();
    firstNameController.dispose();
    cardHolderNameController.dispose();
    lastNameController.dispose();
    houseNumberController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateOfBirthController.dispose();
    lineController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    cityController.dispose();
    countryController.dispose();
    idTypeController.dispose();
    // Dynamically-created controllers collected while building the
    // create-card form (see getStrowalletCardCreateInfo).
    for (final fieldController in inputFieldControllers) {
      if (fieldController != updateProfileController.phoneNumberController &&
          fieldController != updateProfileController.emailController) {
        fieldController.dispose();
      }
    }
    super.onClose();
  }

  // List.clear() drops the references without disposing them — dispose each
  // dynamically-created controller first so re-fetching the create-card
  // fields doesn't leak the old ones. Skip the two entries borrowed from
  // updateProfileController, which owns and disposes them itself.
  void _disposeAndClearInputFieldControllers() {
    for (final fieldController in inputFieldControllers) {
      if (fieldController != updateProfileController.phoneNumberController &&
          fieldController != updateProfileController.emailController) {
        fieldController.dispose();
      }
    }
    inputFieldControllers.clear();
  }

  @override
  void onInit() {
    dashboardController.getDashboardData().then((value) {
      if (dashboardController.dashBoardModel.data.activeVirtualSystem ==
          'strowallet') {
        getStrowalletCardData();
        // NOTE: the old `update/customer/status` endpoint was removed from the
        // API (returns 404) — calling it popped a spurious "Something went
        // Wrong!" snackbar on the home screen. Card-holder status now comes
        // straight from the card / create-info payloads.
        getStrowalletCardCreateInfo();
      }
    });

    super.onInit();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Reactive tick bumped on each card (re)load so the home "YOUR CARDS"
  // section rebuilds when the async fetch finishes (the model isn't an Rx).
  final RxInt cardsRevision = 0.obs;

  // True only once the card model has loaded successfully, so the failure
  // path never reads the uninitialised `late` field (LateInitializationError).
  final _hasCardData = false.obs;
  bool get hasCardData => _hasCardData.value;

  late StrowalletCardModel _strowalletCardModel;
  StrowalletCardModel get strowalletCardModel => _strowalletCardModel;

  Future<StrowalletCardModel?> getStrowalletCardData() async {
    _isLoading.value = true;
    update();

    await StrowalletApiServices.strowalletCardInfoApi()
        .then((value) {
          // `value` is null when the service already failed (network error,
          // non-200 status, or a parse error) and logged/snackbarred it —
          // force-unwrapping it here used to throw "Null check operator used
          // on a null value" on top of the original failure. Just stop: the
          // screen stays on its current/empty state instead of crashing.
          if (value == null) return;
          _strowalletCardModel = value;
          _hasCardData.value = true;
          cardsRevision.value++;

          if (_strowalletCardModel.data.myCards.isNotEmpty) {
            strowalletCardId.value =
                _strowalletCardModel.data.myCards.first.cardId;
          }
          _calculation();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _hasCardData.value ? _strowalletCardModel : null;
  }

  //>> with out loading
  Future<StrowalletCardModel?> getStrowalletCardInfo() async {
    update();

    await StrowalletApiServices.strowalletCardInfoApi()
        .then((value) {
          if (value == null) return;
          _strowalletCardModel = value;
          _hasCardData.value = true;
          cardsRevision.value++;

          if (_strowalletCardModel.data.myCards.isNotEmpty) {
            strowalletCardId.value =
                _strowalletCardModel.data.myCards.first.cardId;
          }
          _calculation();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    update();
    return _hasCardData.value ? _strowalletCardModel : null;
  }

  ///  >>>>>> Start buyCard process
  final _isBuyCardLoading = false.obs;
  bool get isBuyCardLoading => _isBuyCardLoading.value;
  late CommonSuccessModel _buyCardModel;
  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel> buyCardProcess(context) async {
    _isBuyCardLoading.value = true;
    update();
    // Strowallet buy-card (latest API) takes only the amount + currencies.
    // The card-holder name now lives in the dedicated card-holder record
    // (store/card-holder) and is no longer sent here.
    final String baseCurrency = LocalStorage.getBaseCurrency() ?? 'USD';
    Map<String, dynamic> inputBody = {
      "card_amount": fundAmountController.text,
      "currency": baseCurrency,
      "from_currency": baseCurrency,
    };
    await StrowalletApiServices.strowalletBuyCardApi(body: inputBody)
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
    CardCharge data = _strowalletCardModel.data.cardCharge;
    double amount = 0.0;

    if (fundAmountController.text.isNotEmpty) {
      try {
        amount = double.parse(fundAmountController.text);
      } catch (e) {
        // print('Error parsing double: $e');
      }
    }

    percentCharge.value = ((amount / 100) * data.percentCharge);
    totalCharge.value =
        double.parse(data.fixedCharge.toString()) + percentCharge.value;
    totalPay.value = amount + totalCharge.value;
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

    await StrowalletApiServices.strowalletCardMakeOrRemoveDefaultApi(
          body: inputBody,
        )
        .then((value) {
          _cardDefaultModel = value!;
          getStrowalletCardData();
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isMakeDefaultLoading.value = false;
    update();
    return _cardDefaultModel;
  }

  /// Get Strowallet Card Create Info
  /// Get Strowallet Card Create Info
  /// Get Strowallet Card Create Info
  /// Get Strowallet Card Create Info
  /// Get Strowallet Card Create Info

  final _isCreateCardInfoLoading = false.obs;
  bool get isCreateCardInfoLoading => _isCreateCardInfoLoading.value;

  // True only once the create-info model has loaded successfully, so the
  // screen never reads the uninitialised `late` _strowalletCardCreateInfo
  // (LateInitializationError red screen) when the API fails.
  final _isCreateInfoLoaded = false.obs;
  bool get isCreateInfoLoaded => _isCreateInfoLoaded.value;

  late StrowalletCardCreateInfo _strowalletCardCreateInfo;
  StrowalletCardCreateInfo get strowalletCardCreateInfo =>
      _strowalletCardCreateInfo;

  Future<StrowalletCardCreateInfo?> getStrowalletCardCreateInfo() async {
    _disposeAndClearInputFieldControllers();
    inputFields.clear();
    return RequestProcess().request<StrowalletCardCreateInfo>(
      fromJson: StrowalletCardCreateInfo.fromJson,
      apiEndpoint: ApiEndpoint.strowalletCardInfo,
      isLoading: _isCreateCardInfoLoading,
      onSuccess: (value) {
        _strowalletCardCreateInfo = value!;
        _isCreateInfoLoaded.value = true;
        final data = _strowalletCardCreateInfo.data.customerCreateFields;
        if (strowalletCardCreateInfo.data.customerExistStatus) {
          appBarTitle.value =
              Get.find<LanguageController>().getTranslation(Strings.createCard);
        } else {
          appBarTitle.value = Get.find<LanguageController>()
              .getTranslation(Strings.createCardCustomer);
        }

        for (int item = 0; item < data.length; item++) {
          // If the current item type is 'phone', use the controller from updateProfileController
          if (data[item].type.contains('phone')) {
            inputFieldControllers.add(
              updateProfileController.phoneNumberController,
            ); // Use phoneController for phone input
          } else if (data[item].type.contains('email')) {
            inputFieldControllers.add(updateProfileController.emailController);
          } else {
            // For other types, dynamically create a controller
            var textEditingController = TextEditingController();
            inputFieldControllers.add(textEditingController);
          }

          if (data[item].type.contains('file')) {
            hasFile.value = true;
            inputFields.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ImageWidget(
                  labelName: data[item].labelName,
                  fieldName: data[item].fieldName,
                  optionalLabel: data[item].siteLabel != ''
                      ? "(*${data[item].siteLabel})"
                      : data[item].siteLabel,
                ),
              ),
            );
          } else if (data[item].type.contains('text') ||
              data[item].type.contains('textarea') ||
              data[item].type.contains('email') ||
              data[item].type.contains('number')) {
            if (data[item].type.contains('number')) {
              if (data[item].fieldName.contains('phone_code')) {
              } else {
                // Use phone controller for phone input
                inputFields.add(
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.heightSize * 0.5,
                    ),
                    child: PhoneNumberInputWidget(
                      readOnly: true,
                      countryCode: updateProfileController.selectedCountryCode,
                      controller: updateProfileController.phoneNumberController,
                      label: data[item].labelName,
                      hint:
                          "${Get.find<LanguageController>().getTranslation(Strings.enter)} ${data[item].labelName}",
                      optionalLabel: data[item].siteLabel != ''
                          ? "(*${data[item].siteLabel})"
                          : data[item].siteLabel,
                    ),
                  ),
                );
              }
            } else {
              inputFields.add(
                Column(
                  children: [
                    PrimaryInputWidget(
                      paddings: EdgeInsets.only(
                        left: Dimensions.widthSize,
                        right: Dimensions.widthSize,
                        top: Dimensions.heightSize * 0.5,
                      ),
                      controller:
                          inputFieldControllers[item], // Use dynamic controller for other inputs
                      label: data[item].labelName,
                      hint:
                          "${Get.find<LanguageController>().getTranslation(Strings.enter)} ${data[item].labelName}",
                      optionalLabel: data[item].siteLabel != ''
                          ? "*(${data[item].siteLabel})"
                          : data[item].siteLabel,
                      isValidator: true,
                    ),
                    verticalSpace(Dimensions.heightSize * 0.8),
                  ],
                ),
              );
            }
          } else if (data[item].type.contains('date')) {
            inputFields.add(
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.heightSize * 0.5,
                ),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1930),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final DateFormat formatter = DateFormat('MM/dd/yyyy');
                      final String formattedDate = formatter.format(pickedDate);
                      inputFieldControllers[item].text = formattedDate;
                    }
                  },
                  child: AbsorbPointer(
                    child: PrimaryInputWidget(
                      controller:
                          inputFieldControllers[item], // Use dynamic controller for date
                      label: data[item].labelName,
                      hint:
                          "${Get.find<LanguageController>().getTranslation(Strings.enter)} ${data[item].labelName}",
                      optionalLabel: data[item].siteLabel != ''
                          ? "*(${data[item].siteLabel})"
                          : data[item].siteLabel,
                      isValidator: true,
                    ),
                  ),
                ),
              ),
            );
          }
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
    Map<String, dynamic> inputBody = {};
    final data = _strowalletCardCreateInfo.data.customerCreateFields;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].fieldName] = inputFieldControllers[i].text;
      }
    }
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.strowalletCreateCustomerURL,
      isLoading: _isCustomerCreateLoading,
      method: HttpMethod.POST,
      fieldList: listFieldName,
      pathList: listImagePath,
      showSuccessMessage: true,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

  ///
  final _isStatusLoading = false.obs;
  bool get isStatusLoading => _isStatusLoading.value;

  late CommonSuccessModel _statusUpdateModel;
  CommonSuccessModel get statusUpdateModel => _statusUpdateModel;

  Future<CommonSuccessModel?> customerStatusUpdate() async {
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.strowalletCreateCustomerStatusURl,
      isLoading: _isStatusLoading,
      onSuccess: (value) {
        _statusUpdateModel = value!;
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
