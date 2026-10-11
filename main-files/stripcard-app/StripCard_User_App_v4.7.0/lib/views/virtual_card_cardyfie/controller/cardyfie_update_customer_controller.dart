import 'package:intl/intl.dart';

import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/cardyfie_model/card_edit_info_model_cardyfie.dart";
import "package:TAKARA PAY/base/api/model/virtual_card/sudo_models/sudo_card_model.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";
import "package:TAKARA PAY/base/utils/request_process.dart";
import "package:TAKARA PAY/routes/routes.dart";
import "package:TAKARA PAY/base/utils/basic_widget_import.dart";
import "package:TAKARA PAY/views/virtual_card_cardyfie/controller/cardyfie_info_controller.dart";

class UpdateCustomerCardyfieController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final controller = Get.put(VirtualCardyfieCardController());
  final fundAmountController = TextEditingController();

  final RxString fontImage = "".obs;
  final RxString backImage = "".obs;

  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final identifyNumberController = TextEditingController();
  final houseNumberController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();

  final cardHolderNameController = TextEditingController();
  final idNumberController = TextEditingController();
  final phoneController = TextEditingController();
  final lineController = TextEditingController();
  final countryController = TextEditingController();
  final idTypeController = TextEditingController();
  RxString selectedCountry = 'Select Country'.obs;
  RxString countryISO2 = ''.obs;
  final RxString selectTypeName = 'Select Type'.obs;
  final RxString selectTypeSlug = 'nid'.obs;
  // for customer create
  final List<Map<String, String>> identityList = [
    {'name': 'National ID Card (NID)', 'slug': 'nid'},
    {'name': 'Passport', 'slug': 'passport'},
    {'name': 'Bank Verification Number', 'slug': 'bvn'},
  ];

  // for card tier
  final RxString selectTierName = 'Select Card Tier'.obs;
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
  RxString idImageFont = ''.obs;
  RxString idImageBack = ''.obs;
  RxString userPhoto = ''.obs;
  var selectedDate = Rxn<DateTime>();
  RxString dateTextValue = ''.obs;
  final dateTextController = TextEditingController();
  RxString selectedIdentityType = "Select Type".obs;
  List<Option> identityTypeList = [
    Option(id: 1, name: "National ID Card (NID)", value: "nid"),
    Option(id: 2, name: "Passport", value: "passport"),
    Option(id: 3, name: "Bank Verification Number", value: "bvn"),
  ];

  @override
  void onInit() {
    getCaryfieCardCreateInfo();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    fundAmountController.dispose();
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
    dateTextController.dispose();
    super.onClose();
  }

  final _isCreateCardInfoLoading = false.obs;
  bool get isCreateCardInfoLoading => _isCreateCardInfoLoading.value;

  late CardyfieCardCreateInfo _cardyfieCardCreateInfo;
  CardyfieCardCreateInfo get cardyfieCardCreateInfo => _cardyfieCardCreateInfo;

  Future<CardyfieCardCreateInfo?> getCaryfieCardCreateInfo() async {
    controller.listImagePath.clear();
    controller.listFieldName.clear();
    return RequestProcess().request<CardyfieCardCreateInfo>(
      fromJson: CardyfieCardCreateInfo.fromJson,
      apiEndpoint: ApiEndpoint.cardyfieEditCustomer,
      isLoading: _isCreateCardInfoLoading,
      onSuccess: (value) {
        _cardyfieCardCreateInfo = value!;
        final data = _cardyfieCardCreateInfo.data.cardCustomer;
        debugPrint(data.userImage);
        debugPrint("*******");

        firstNameController.text = data.firstName;
        lastNameController.text = data.lastName;
        idImageFont.value = data.idFontImage;
        idImageBack.value = data.idBackImage;
        userPhoto.value = data.userImage;
        emailController.text = data.email;
        identifyNumberController.text = data.idNumber;
        cityController.text = data.city;
        stateController.text = data.state;
        addressController.text = data.addressLine1;
        zipcodeController.text = data.zipCode;
        dateOfBirthController.text = data.dateOfBirth;
        selectTypeName.value = data.idType;
        houseNumberController.text = data.houseNumber;
        selectedCountry.value = data.country;
        fontImage.value = data.idFontImage;
        backImage.value = data.idBackImage;
      },
    );
  }

  // update customer kyc

  final _isConfirmLoading = false.obs;
  bool get isConfirmLoading => _isConfirmLoading.value;

  late CommonSuccessModel _commonSuccessModel;
  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  Future<CommonSuccessModel?> updateCustomerKyc() async {
    Map<String, dynamic> inputBody = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'date_of_birth': dateOfBirthController.text,
      'identity_type': selectTypeSlug.value,
      'identity_number': identifyNumberController.text,
      'house_number': houseNumberController.text,
      'state': stateController.text,
      'zip_code': zipcodeController.text,
      'address': addressController.text,
      'city': cityController.text,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.cardifyUpdateCustomerURl,
      isLoading: _isConfirmLoading,
      method: HttpMethod.POST,
      body: inputBody,

      fieldList: controller.listFieldName,
      pathList: controller.listImagePath,
      showSuccessMessage: true,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.toNamed(Routes.bottomNavBarScreen);
      },
    );
  }

  // Date Picker

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2008),
      firstDate: DateTime(1990),
      lastDate: DateTime(2008),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColor.primaryBGLightColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColor.primaryBGLightColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      selectedDate.value = pickedDate;

      dateTextController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      dateTextValue.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }
  // image picker

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
