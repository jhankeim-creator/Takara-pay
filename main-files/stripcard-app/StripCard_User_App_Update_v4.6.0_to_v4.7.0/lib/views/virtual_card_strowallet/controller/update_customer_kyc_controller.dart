import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import "package:TAKARA PAY/base/api/model/common/common_success_model.dart";
import "package:TAKARA PAY/base/api/model/profile/profile_info_model.dart";
import "package:TAKARA PAY/base/api/endpoint/api_endpoint.dart";
import "package:TAKARA PAY/base/api/services/api_services.dart";
import "package:TAKARA PAY/base/api/services/strowallet_api_services.dart";
import "package:TAKARA PAY/base/utils/custom_snackbar.dart";
import "package:TAKARA PAY/base/utils/data/strowallet_card_holder_options.dart";
import "package:TAKARA PAY/base/utils/language/language_controller.dart";
import "package:TAKARA PAY/base/utils/language/strings.dart";
import "package:TAKARA PAY/base/utils/request_process.dart";
import "package:TAKARA PAY/views/virtual_card_strowallet/controller/strowallelt_info_controller.dart";

/// Manages the Strowallet "Card Holder" record (latest API):
///   GET  /user/strowallet-card/get/card-holder    → prefill
///   POST /user/strowallet-card/store/card-holder   → create/update (upsert)
///
/// Replaces the old image-based create/update-customer KYC flow.
///
/// GET get/card-holder answers with a non-200 status (400) for "not created
/// yet" — see StrowalletApiServices.strowalletGetCardHolderApi — so this
/// controller's state is a 3-way result of that call, never a plain
/// success/failure bool: [CardHolderState.loading] while in flight,
/// [CardHolderState.exists] (read-only) or [CardHolderState.notCreated]
/// (editable create form) on a classified response, [CardHolderState.failed]
/// for a genuine network/server error (never falls back to the editable form).
enum CardHolderState { loading, exists, notCreated, failed }

class UpdateCustomerKycController extends GetxController {
  final nameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final line1Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final phoneCodeController = TextEditingController();
  final phoneController = TextEditingController();

  /// id_type accepted values per the API contract.
  static const List<String> idTypeOptions = [
    'national_id',
    'passport',
    'drivers_license',
  ];
  final RxString idType = 'national_id'.obs;

  // account_purpose / employment_status / occupation: valid raw values and
  // their display labels live in StrowalletCardHolderOptions (static, not
  // translated — the backend's language dictionary doesn't carry these keys).
  final Rxn<String> accountPurpose = Rxn<String>();
  final Rxn<String> employmentStatus = Rxn<String>();
  final Rxn<String> occupation = Rxn<String>();

  /// id_image: optional (required only if the user has no existing KYC
  /// image on file — enforced server-side). Backend rule: image, mimes:
  /// jpg/png/svg/webp, max 10240 KB.
  static const List<String> allowedIdImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'svg',
    'webp',
  ];
  static const int maxIdImageBytes = 10 * 1024 * 1024;
  final Rxn<File> idImageFile = Rxn<File>();

  Future<void> pickIdImage(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        // Forces a JPEG re-encode on iOS, avoiding HEIC files the backend rejects.
        imageQuality: 80,
      );
      if (picked == null) return;

      final extension = picked.path.split('.').last.toLowerCase();
      if (!allowedIdImageExtensions.contains(extension)) {
        CustomSnackBar.error(
            Get.find<LanguageController>().getTranslation(Strings.invalidImageFormat));
        return;
      }

      final file = File(picked.path);
      if (await file.length() > maxIdImageBytes) {
        CustomSnackBar.error(
            Get.find<LanguageController>().getTranslation(Strings.imageTooLarge));
        return;
      }

      idImageFile.value = file;
    } on PlatformException catch (e) {
      CustomSnackBar.error('Error: $e');
    }
  }

  // Country selector — the strowallet API requires a valid ISO-3 country code
  // (e.g. USA/NGA/HTI). A free-text field let users type garbage ("gfds") which
  // the buy-card API then rejected ("selected country is invalid"). So we load
  // the real country list and store the selected ISO-3.
  final RxList<Country> countries = <Country>[].obs;
  final RxString selectedCountryIso3 = ''.obs;

  @override
  void onInit() {
    loadCountries();
    getCardHolder();
    super.onInit();
  }

  Future<void> loadCountries() async {
    try {
      final profile = await ApiServices.userProfileApi();
      final list = profile?.data.countries ?? const <Country>[];
      countries.assignAll(list);
      // If a card-holder already preset a country, keep it selected.
      _syncSelectedCountry();
    } catch (_) {
      // Country list unavailable — the dropdown simply shows nothing to pick.
    }
  }

  // Align selectedCountryIso3 with whatever is in countryController (from an
  // existing card-holder or profile), matching by iso3 or country name.
  void _syncSelectedCountry() {
    final current = countryController.text.trim();
    if (current.isEmpty || countries.isEmpty) return;
    for (final c in countries) {
      if ('${c.iso3}'.toUpperCase() == current.toUpperCase() ||
          '${c.name}'.toLowerCase() == current.toLowerCase()) {
        selectedCountryIso3.value = '${c.iso3}';
        return;
      }
    }
  }

  final _isCreateCardInfoLoading = false.obs;
  bool get isCreateCardInfoLoading => _isCreateCardInfoLoading.value;

  final Rx<CardHolderState> cardHolderState = CardHolderState.loading.obs;

  // Derived from cardHolderState so existing reads elsewhere keep working
  // unchanged. isLoaded must be true ONLY for a successfully classified
  // result (exists or notCreated) — NOT merely "not loading" — otherwise
  // `failed` would also read as loaded with isReadOnly=false and the
  // screen's `isLoaded ? (isReadOnly ? readOnly : editable) : errorState`
  // ternary would route a genuine failure straight into the editable form,
  // which is exactly the bug this whole state machine exists to prevent.
  bool get isLoaded =>
      cardHolderState.value == CardHolderState.exists ||
      cardHolderState.value == CardHolderState.notCreated;
  bool get isReadOnly => cardHolderState.value == CardHolderState.exists;

  // id_image path from an existing card-holder, for the read-only preview.
  final RxString existingIdImageUrl = ''.obs;

  Future<void> getCardHolder() async {
    cardHolderState.value = CardHolderState.loading;
    _isCreateCardInfoLoading.value = true;
    try {
      final result = await StrowalletApiServices.strowalletGetCardHolderApi();
      switch (result.status) {
        case StrowalletCardHolderFetchStatus.exists:
          final ch = result.model!.data.cardHolder!;
          nameController.text = ch.name;
          firstNameController.text = ch.firstName;
          lastNameController.text = ch.lastName;
          dobController.text = ch.dob;
          if (idTypeOptions.contains(ch.idType)) idType.value = ch.idType;
          idNumberController.text = ch.idNumber;
          emailController.text = ch.email;
          line1Controller.text = ch.line1;
          cityController.text = ch.city;
          stateController.text = ch.state;
          postalCodeController.text = ch.postalCode;
          countryController.text = ch.country;
          phoneCodeController.text = ch.phoneCode;
          phoneController.text = ch.phone;
          existingIdImageUrl.value = ch.idImage;
          if (StrowalletCardHolderOptions.accountPurpose
              .any((o) => o.value == ch.accountPurpose)) {
            accountPurpose.value = ch.accountPurpose;
          }
          if (StrowalletCardHolderOptions.employmentStatus
              .any((o) => o.value == ch.employmentStatus)) {
            employmentStatus.value = ch.employmentStatus;
          }
          if (StrowalletCardHolderOptions.occupation
              .any((o) => o.value == ch.occupation)) {
            occupation.value = ch.occupation;
          }
          _syncSelectedCountry();
          cardHolderState.value = CardHolderState.exists;
          break;
        case StrowalletCardHolderFetchStatus.notCreated:
          // No card-holder yet (expected for new users, not a failure) →
          // seed the form from the user's profile so they don't re-type info
          // we already have (name, email, address, phone).
          existingIdImageUrl.value = '';
          _prefillFromProfile();
          _syncSelectedCountry();
          cardHolderState.value = CardHolderState.notCreated;
          break;
        case StrowalletCardHolderFetchStatus.failed:
          // Network error, timeout, unexpected status, or a parse failure —
          // never falls back to the editable form.
          cardHolderState.value = CardHolderState.failed;
          break;
      }
    } finally {
      // Always leave the loading state, success or failure, so the screen
      // can never get stuck on the loading skeleton.
      _isCreateCardInfoLoading.value = false;
    }
    update();
  }

  // Seed the card-holder form from the user's profile (the strowallet card-info
  // payload carries the full user + address). Only empty fields are filled, so
  // a partially-typed form is never clobbered. `country` is intentionally left
  // blank: the API expects an ISO-3 code (USA/NGA/HTI) while the profile stores
  // a country name, so the user picks it explicitly. Never throws.
  void _prefillFromProfile() {
    try {
      if (!Get.isRegistered<VirtualStrowalletCardController>()) return;
      final c = Get.find<VirtualStrowalletCardController>();
      if (!c.hasCardData) return;
      final u = c.strowalletCardModel.data.user;

      void seed(TextEditingController f, String v) {
        if (f.text.trim().isEmpty && v.trim().isNotEmpty) f.text = v;
      }

      final full = '${u.firstname} ${u.lastname}'.trim();
      seed(nameController, full);
      seed(firstNameController, u.firstname);
      seed(lastNameController, u.lastname);
      seed(emailController, u.email);
      seed(line1Controller, u.address.address);
      seed(cityController, u.address.city);
      seed(stateController, u.address.state);
      seed(postalCodeController, u.address.zip);
      seed(phoneCodeController, u.mobileCode ?? '');
      seed(phoneController, u.mobile);
    } catch (_) {
      // Profile not available — leave the form blank for manual entry.
    }
  }

  final _isConfirmLoading = false.obs;
  bool get isConfirmLoading => _isConfirmLoading.value;

  Future<CommonSuccessModel?> storeCardHolder() async {
    // Defense in depth — the screen already hides the Submit button unless
    // cardHolderState is notCreated, so this should never be reachable
    // otherwise (including from the read-only Customer Details screen).
    if (cardHolderState.value != CardHolderState.notCreated) return null;

    final Map<String, dynamic> body = {
      'name': nameController.text.trim(),
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'dob': dobController.text.trim(),
      'id_type': idType.value,
      'id_number': idNumberController.text.trim(),
      'email': emailController.text.trim(),
      'line1': line1Controller.text.trim(),
      'city': cityController.text.trim(),
      'state': stateController.text.trim(),
      'postal_code': postalCodeController.text.trim(),
      // Always the validated ISO-3 code from the dropdown.
      'country': selectedCountryIso3.value.trim(),
      'phone_code': phoneCodeController.text.trim(),
      'phone': phoneController.text.trim(),
      'account_purpose': accountPurpose.value ?? '',
      'employment_status': employmentStatus.value ?? '',
      'occupation': occupation.value ?? '',
    };

    // Always sent as multipart so id_image (optional) can ride along with the
    // same request when picked; fieldList/pathList are empty when it isn't.
    final file = idImageFile.value;
    final fieldList = file != null ? ['id_image'] : <String>[];
    final pathList = file != null ? [file.path] : <String>[];

    // showSuccessMessage is intentionally false: the screen pops back FIRST and
    // then shows the success snackbar, so GetX doesn't pop the snackbar overlay
    // instead of the page (a known collision when Get.back runs right after an
    // API-layer Get.snackbar).
    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.strowalletStoreCardHolderURL,
      isLoading: _isConfirmLoading,
      method: HttpMethod.POST,
      body: body,
      fieldList: fieldList,
      pathList: pathList,
      showSuccessMessage: false,
      onSuccess: (_) {
        // The holder now exists — matters if this controller instance
        // somehow outlives the screen pop (e.g. a future caller that
        // doesn't navigate away immediately after a successful create).
        cardHolderState.value = CardHolderState.exists;
      },
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    idNumberController.dispose();
    emailController.dispose();
    line1Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    phoneCodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
