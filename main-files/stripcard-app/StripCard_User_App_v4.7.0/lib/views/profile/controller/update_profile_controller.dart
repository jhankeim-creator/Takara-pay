import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/profile/profile_info_model.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/routes/routes.dart";
import "package:TAKARA PAY/base/widgets/others/image_picker/image_picker.dart";

class UpdateProfileController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final stateController = TextEditingController();
  final imageController = Get.put(InputImageController());

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    countryController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    stateController.dispose();
    super.onClose();
  }

  RxString selectedCountryCode = ''.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedCity = ''.obs;
  RxString iso2 = ''.obs;

  File? image;
  RxBool haveImage = false.obs;
  final picker = ImagePicker();

  @override
  void onInit() {
    getUserProfileData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  final _isUpdateLoading = false.obs;

  bool get isUpdateLoading => _isUpdateLoading.value;

  // True only once the profile model has loaded successfully, so the screen
  // never reads the uninitialised `late` model (LateInitializationError red
  // screen) when the profile API fails.
  final _isLoaded = false.obs;

  bool get isLoaded => _isLoaded.value;

  late ProfileModel _userProfileModel;

  ProfileModel get userProfileModel => _userProfileModel;

  Future<ProfileModel> getUserProfileData() async {
    _isLoading.value = true;
    update();

    await ApiServices.userProfileApi()
        .then((value) {
          _userProfileModel = value!;
          _isLoaded.value = true;
          final data = _userProfileModel.data.user;
          firstNameController.text = data.firstname;
          lastNameController.text = data.lastname;
          emailController.text = data.email;
          countryController.text = data.address?.country ?? '';
          cityController.text = data.address?.city ?? '';
          zipCodeController.text = data.address?.zip ?? '';
          addressController.text = data.address?.address ?? '';
          phoneNumberController.text = data.mobile;
          stateController.text = data.address?.state ?? '';
          selectedCountry.value = data.address?.country ?? '';
          selectedCity.value = data.address?.city ?? '';
          iso2.value = _userProfileModel.data.countries.first.iso2;
          selectedCountry.value = _userProfileModel.data.countries.first.name;
          getPhoneCodeAndCountry(data);
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isLoading.value = false;
    update();
    return _userProfileModel;
  }

  RxInt selectValue = 0.obs;

  late CommonSuccessModel _profileUpdateModel;

  CommonSuccessModel get profileUpdateModel => _profileUpdateModel;

  Future<CommonSuccessModel> profileUpdateWithOutImageProcess() async {
    _isUpdateLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'country': selectedCountry.value,
      'phone_code': selectedCountryCode.value,
      'phone': phoneNumberController.text,
      'state': stateController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
      'address': addressController.text,
    };

    await ApiServices.updateProfileWithoutImageApi(body: inputBody)
        .then((value) {
          _profileUpdateModel = value!;
          Get.offAllNamed(Routes.bottomNavBarScreen);
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isUpdateLoading.value = false;
    update();
    return _profileUpdateModel;
  }

  // Profile update process with image
  Future<CommonSuccessModel> profileUpdateWithImageProcess() async {
    _isUpdateLoading.value = true;
    update();

    Map<String, String> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'country': countryController.text,
      'phone_code': selectedCountryCode.value,
      'phone': phoneNumberController.text,
      'state': stateController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
      'address': addressController.text,
    };

    await ApiServices.updateProfileWithImageApi(
          body: inputBody,
          filepath: imageController.imagePath.value,
        )
        .then((value) {
          _profileUpdateModel = value!;
          Get.offAllNamed(Routes.bottomNavBarScreen);
          update();
        })
        .catchError((onError) {
          log.e(onError);
        });

    _isUpdateLoading.value = false;
    update();
    return _profileUpdateModel;
  }

  void gotoNavigation() {
    Get.offAllNamed(Routes.bottomNavBarScreen);
  }

  void getPhoneCodeAndCountry(data) {
    // New accounts have mobile_code/address as null (not empty strings) —
    // dereferencing them directly crashed the profile screen.
    final String code = '${data.mobileCode ?? ''}';
    if (code.isNotEmpty) {
      selectedCountryCode.value = code;
    } else {
      selectedCountryCode.value =
          '${_userProfileModel.data.countries.first.mobileCode ?? ''}';
    }
    final String country = '${data.address?.country ?? ''}';
    if (country.isNotEmpty) {
      selectedCountry.value = country;
    } else {
      selectedCountry.value =
          '${_userProfileModel.data.countries.first.name ?? ''}';
    }
  }
}
