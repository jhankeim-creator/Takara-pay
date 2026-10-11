import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const String idKey = "idKey";

const String nameKey = "nameKey";

const String tokenKey = "tokenKey";

const String emailKey = "emailKey";
const String splashImgKey = "splashImgKey";
const String basicImgKey = "basicImgKey";

const String imageKey = "imageKey";

const String showAdKey = "showAdKey";
const String productId = "product_id";

const String isLoggedInKey = "isLoggedInKey";

const String isDataLoadedKey = "isDataLoadedKey";

const String isOnBoardDoneKey = "isOnBoardDoneKey";

const String isScheduleEmptyKey = "isScheduleEmptyKey";
const String privacyPolicyLinkKey = "privacyPolicyLinkKey";

const String language = "language";

const String smallLanguage = "smallLanguage";

const String capitalLanguage = "capitalLanguage";
const String baseCurrency = "baseCurrency";
const String kycKey = "kycKey";

const String onboardTitleKey = "onboardTitleKey";
const String onboardSubTitleKey = "onboardSubTitleKey";
const String logoDarkImageKey = "logoDarkImageKey";
const String logoLightImageKey = "logoLightImageKey";
const String splashScreenImageKey = "logoLightImageKey";
const String onboardScreenImageKey = "logoLightImageKey";
const String virtualImageKey = "virtualImageKey";
const String emailVerificationKey = "emailVerificationKey";
const String isPusherAuthenticationKey = "isPusherAuthenticationKey";

// Biometric "sign in with fingerprint / Face ID" — these intentionally
// SURVIVE a normal logout so the user can quickly re-enter with biometrics.
// Cleared only via disableBiometric().
const String biometricEnabledKey = "biometricEnabledKey";
const String biometricTokenKey = "biometricTokenKey";
const String biometricEmailKey = "biometricEmailKey";
const String biometricPasswordKey = "biometricPasswordKey";

// Last successful /app-settings/languages response (JSON-encoded), used by
// LanguageController so a flaky language API still has real cached
// translations to fall back on instead of only the bundled English map.
const String cachedLanguagesKey = "cachedLanguagesKey";

class LocalStorage {
  // Session token and biometric credentials are the actual keys to the
  // user's account, so they live in OS-backed secure storage (Keychain on
  // iOS, Keystore-backed EncryptedSharedPreferences on Android) instead of
  // GetStorage's plaintext JSON file. flutter_secure_storage's API is
  // async-only, but every call site here expects a synchronous read (the
  // token is read on every single API request), so the decrypted value is
  // also kept in a static in-memory cache, primed once at startup by
  // [primeSecureCache] and kept in sync on every write/clear below.
  static const _secure = FlutterSecureStorage();
  static String? _cachedToken;
  static String? _cachedBiometricToken;
  static String? _cachedBiometricPassword;

  /// Call once during app boot (after GetStorage.init()). Loads the secure
  /// values into memory and, on first run after upgrading from the old
  /// plaintext-GetStorage storage, migrates any existing token/biometric
  /// credentials over instead of silently signing the user out.
  static Future<void> primeSecureCache() async {
    _cachedToken = await _secure.read(key: tokenKey);
    _cachedBiometricToken = await _secure.read(key: biometricTokenKey);
    _cachedBiometricPassword = await _secure.read(key: biometricPasswordKey);

    final box = GetStorage();
    if (_cachedToken == null) {
      final legacyToken = box.read(tokenKey);
      if (legacyToken is String && legacyToken.isNotEmpty) {
        _cachedToken = legacyToken;
        await _secure.write(key: tokenKey, value: legacyToken);
      }
    }
    await box.remove(tokenKey);

    if (_cachedBiometricToken == null || _cachedBiometricPassword == null) {
      final legacyBioToken = box.read(biometricTokenKey);
      final legacyBioPassword = box.read(biometricPasswordKey);
      if (legacyBioToken is String && legacyBioToken.isNotEmpty) {
        _cachedBiometricToken = legacyBioToken;
        await _secure.write(key: biometricTokenKey, value: legacyBioToken);
      }
      if (legacyBioPassword is String && legacyBioPassword.isNotEmpty) {
        _cachedBiometricPassword = legacyBioPassword;
        await _secure.write(key: biometricPasswordKey, value: legacyBioPassword);
      }
    }
    await box.remove(biometricTokenKey);
    await box.remove(biometricPasswordKey);
  }

  static Future<void> saveBaseCurrency({required String currency}) async {
    final box = GetStorage();

    await box.write(baseCurrency, currency);
  }

  static Future<void> saveKycStatus({required int status}) async {
    final box = GetStorage();

    await box.write(kycKey, status);
  }

  static int? getKyc() {
    return GetStorage().read(kycKey);
  }

  static String? getBaseCurrency() {
    return GetStorage().read(baseCurrency);
  }

//splash screen logo
  static Future<void> saveSplashImage({required String image}) async {
    final box = GetStorage();

    await box.write(splashImgKey, image);
  }

  static String getSplashImage() {
    return GetStorage().read(splashImgKey);
  }

//virtual image key
  static Future<void> saveVirtualImage({required String virtualImage}) async {
    final box = GetStorage();

    await box.write(virtualImageKey, virtualImage);
  }

  static String getVirtualImage() {
    return GetStorage().read(virtualImageKey);
  }

//basic logo
  static Future<void> saveBasicImage({required String image}) async {
    final box = GetStorage();

    await box.write(basicImgKey, image);
  }

  static String getBasicImage() {
    return GetStorage().read(basicImgKey);
  }

  ///>>>>>> save privacy policy
  static Future<void> savePrivacyPolicyLink({required String link}) async {
    final box = GetStorage();

    await box.write(privacyPolicyLinkKey, link);
  }

  ///>>>> get privacy policy
  static String getPrivacyPolicy() {
    return GetStorage().read(privacyPolicyLinkKey) ?? '';
  }

  //save email

  static Future<void> saveEmail({required String email}) async {
    final box = GetStorage();

    await box.write(emailKey, email);
  }

  static Future<void> saveId({required String id}) async {
    final box = GetStorage();

    await box.write(idKey, id);
  }

  static String getProductId() {
    return GetStorage().read(productId) ?? "";
  }

  static Future<void> saveProductId({required String id}) async {
    final box = GetStorage();
    await box.write(productId, id);
  }

  static Future<void> saveName({required String name}) async {
    final box = GetStorage();

    await box.write(nameKey, name);
  }

  static Future<void> saveToken({required String token}) async {
    _cachedToken = token;
    await _secure.write(key: tokenKey, value: token);
  }

  static Future<void> saveImage({required String image}) async {
    final box = GetStorage();

    await box.write(imageKey, image);
  }

  static Future<void> isLoginSuccess({required bool isLoggedIn}) async {
    final box = GetStorage();

    await box.write(isLoggedInKey, isLoggedIn);
  }

  static Future<void> dataLoaded({required bool isDataLoad}) async {
    final box = GetStorage();

    await box.write(isDataLoadedKey, isDataLoad);
  }

  static Future<void> scheduleEmpty({required bool isScheduleEmpty}) async {
    final box = GetStorage();

    await box.write(isScheduleEmptyKey, isScheduleEmpty);
  }

  static Future<void> showAdYes({required bool isShowAdYes}) async {
    final box = GetStorage();

    await box.write(showAdKey, isShowAdYes);
  }

  //save email Verification
  static Future<void> emailVerificationSave(
      {required bool isEmailVerification}) async {
    final box = GetStorage();

    await box.write(emailVerificationKey, isEmailVerification);
  }
  
//get email verification
  static bool getEmailVerification() {
    return GetStorage().read(emailVerificationKey) ?? false;
  }

 static Future<void> savePusherAuthenticationKey(
      {required bool pusherAuthenticationKey}) async {
    final box = GetStorage();

    await box.write(isPusherAuthenticationKey, pusherAuthenticationKey);
  }
  static Future<void> saveOnboardDoneOrNot(
      {required bool isOnBoardDone}) async {
    final box = GetStorage();

    await box.write(isOnBoardDoneKey, isOnBoardDone);
  }

  static Future<void> saveLanguage({
    required String langSmall,
    required String langCap,
    required String languageName,
  }) async {
    final box1 = GetStorage();
    final box2 = GetStorage();
    final box3 = GetStorage();
    // languageStateName = languageName;
    var locale = Locale(langSmall, langCap);
    Get.updateLocale(locale);
    await box1.write(smallLanguage, langSmall);
    await box2.write(capitalLanguage, langCap);
    await box3.write(language, languageName);
  }

  static Future<void> saveOnBoardTitle({required String title}) async {
    final box = GetStorage();

    await box.write(onboardTitleKey, title);
  }

  static Future<void> saveOnBoardSubTitle({required String subTitle}) async {
    final box = GetStorage();

    await box.write(onboardSubTitleKey, subTitle);
  }

  static Future<void> saveLogoDarkImage({required String image}) async {
    final box = GetStorage();

    await box.write(logoDarkImageKey, image);
  }

  static Future<void> saveLogoLightImage({required String image}) async {
    final box = GetStorage();

    await box.write(logoLightImageKey, image);
  }

  static Future<void> saveSplashScreenImage({required String image}) async {
    final box = GetStorage();

    await box.write(splashScreenImageKey, image);
  }

  static Future<void> saveOnboardScreenImage({required String image}) async {
    final box = GetStorage();

    await box.write(onboardScreenImageKey, image);
  }

  static List getLanguage() {
    String small = GetStorage().read(smallLanguage) ?? 'en';
    String capital = GetStorage().read(capitalLanguage) ?? 'EN';
    String languages = GetStorage().read(language) ?? 'English';
    return [small, capital, languages];
  }

  static Future<void> changeLanguage() async {
    final box = GetStorage();
    await box.remove(language);
  }

  static String? getId() {
    return GetStorage().read(idKey);
  }

  static String? getName() {
    return GetStorage().read(nameKey);
  }

  static String? getEmail() {
    return GetStorage().read(emailKey);
  }

  static String? getToken() {
    debugPrint(_cachedToken == null ? "##Token is null###" : "");

    return _cachedToken;
  }

  static String? getImage() {
    return GetStorage().read(imageKey);
  }

  static bool isLoggedIn() {
    return GetStorage().read(isLoggedInKey) ?? false;
  }

  static bool isDataLoaded() {
    return GetStorage().read(isDataLoadedKey) ?? false;
  }

  static bool isScheduleEmpty() {
    return GetStorage().read(isScheduleEmptyKey) ?? false;
  }

  static bool isOnBoardDone() {
    return GetStorage().read(isOnBoardDoneKey) ?? false;
  }

  static bool showAdPermission() {
    return GetStorage().read(showAdKey) ?? true;
  }

  static String getLogoDarkImage() {
    return GetStorage().read(logoDarkImageKey) ?? '';
  }

  static String getLogoLightImage() {
    return GetStorage().read(logoLightImageKey) ?? '';
  }

  static String getSplashScreenImage() {
    return GetStorage().read(splashScreenImageKey) ?? '';
  }

  static String getOnboardScreenImage() {
    return GetStorage().read(onboardScreenImageKey) ?? '';
  }

  static String getOnboardTitle() {
    return GetStorage().read(onboardTitleKey) ?? '';
  }

  static String getOnboardSubTitle() {
    return GetStorage().read(onboardSubTitleKey) ?? '';
  }

  // ── Biometric sign-in ────────────────────────────────────────────────────

  /// Remember the session for biometric re-entry. Called after a successful
  /// password login. Persists across logout so "Sign in with fingerprint"
  /// keeps working until the user explicitly disables it.
  static Future<void> enableBiometric({
    required String token,
    required String email,
    required String password,
  }) async {
    final box = GetStorage();
    await box.write(biometricEnabledKey, true);
    await box.write(biometricEmailKey, email);
    // Credentials are stored so biometric sign-in performs a REAL login (fresh
    // token) instead of restoring the old token — which the server invalidates
    // on logout, leaving biometric login to 401 and bounce back to the login
    // screen. Token + password are the actual account credential, so — unlike
    // the email above — they go through secure storage, not plaintext
    // GetStorage.
    _cachedBiometricToken = token;
    _cachedBiometricPassword = password;
    await _secure.write(key: biometricTokenKey, value: token);
    await _secure.write(key: biometricPasswordKey, value: password);
  }

  static bool isBiometricEnabled() {
    return (GetStorage().read(biometricEnabledKey) ?? false) &&
        (GetStorage().read(biometricEmailKey) ?? '').toString().isNotEmpty &&
        (_cachedBiometricPassword ?? '').isNotEmpty;
  }

  static String? getBiometricToken() {
    return _cachedBiometricToken;
  }

  static String? getBiometricEmail() {
    return GetStorage().read(biometricEmailKey);
  }

  static String? getBiometricPassword() {
    return _cachedBiometricPassword;
  }

  static Future<void> disableBiometric() async {
    final box = GetStorage();
    await box.remove(biometricEnabledKey);
    await box.remove(biometricEmailKey);
    _cachedBiometricToken = null;
    _cachedBiometricPassword = null;
    await _secure.delete(key: biometricTokenKey);
    await _secure.delete(key: biometricPasswordKey);
  }

  // ── Language cache ───────────────────────────────────────────────────────

  static Future<void> saveCachedLanguages({required String json}) async {
    final box = GetStorage();
    await box.write(cachedLanguagesKey, json);
  }

  static String? getCachedLanguages() {
    return GetStorage().read(cachedLanguagesKey);
  }

  static Future<void> logout() async {
    final box = GetStorage();

    await box.remove(idKey);

    await box.remove(nameKey);

    await box.remove(emailKey);

    await box.remove(imageKey);

    await box.remove(isLoggedInKey);

    _cachedToken = null;
    await _secure.delete(key: tokenKey);
  }
}
