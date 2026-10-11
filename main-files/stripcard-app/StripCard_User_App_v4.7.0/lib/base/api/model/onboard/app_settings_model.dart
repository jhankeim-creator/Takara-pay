class AppSettingsModel {
  Message message;
  Data data;

  AppSettingsModel({
    required this.message,
    required this.data,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      AppSettingsModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {

  String assetBaseUrl;
  
  String defaultLogo;
  String imagePath;
  List<OnboardScreen> onboardScreen;
  SplashScreen splashScreen;
  AppUrl appUrl;
  AllLogo allLogo;
  String logoImagePath;
  BasicSettingsData basicSettingsData;

  Data({
    required this.assetBaseUrl,
    required this.defaultLogo,
    required this.imagePath,
    required this.onboardScreen,
    required this.splashScreen,
    required this.appUrl,
    required this.allLogo,
    required this.logoImagePath,
    required this.basicSettingsData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        assetBaseUrl: json["asset_base_url"],
        defaultLogo: json["default_logo"],
        imagePath: json["image_path"],
        onboardScreen: List<OnboardScreen>.from(
            json["onboard_screen"].map((x) => OnboardScreen.fromJson(x))),
        splashScreen: SplashScreen.fromJson(json["splash_screen"]),
        appUrl: AppUrl.fromJson(json["app_url"]),
        allLogo: AllLogo.fromJson(json["all_logo"]),
        logoImagePath: json["logo_image_path"],
        basicSettingsData:
            BasicSettingsData.fromJson(json["basic_settings_data"]),
      );

  Map<String, dynamic> toJson() => {
        "asset_base_url": assetBaseUrl,
        "default_logo": defaultLogo,
        "image_path": imagePath,
        "onboard_screen":
            List<dynamic>.from(onboardScreen.map((x) => x.toJson())),
        "splash_screen": splashScreen.toJson(),
        "app_url": appUrl.toJson(),
        "all_logo": allLogo.toJson(),
        "logo_image_path": logoImagePath,
        "basic_settings_data": basicSettingsData.toJson(),
      };
}

class AllLogo {
  String siteLogoDark;
  String siteLogo;
  String siteFavDark;
  String siteFav;

  AllLogo({
    required this.siteLogoDark,
    required this.siteLogo,
    required this.siteFavDark,
    required this.siteFav,
  });

  factory AllLogo.fromJson(Map<String, dynamic> json) => AllLogo(
        siteLogoDark: json["site_logo_dark"],
        siteLogo: json["site_logo"],
        siteFavDark: json["site_fav_dark"],
        siteFav: json["site_fav"],
      );

  Map<String, dynamic> toJson() => {
        "site_logo_dark": siteLogoDark,
        "site_logo": siteLogo,
        "site_fav_dark": siteFavDark,
        "site_fav": siteFav,
      };
}

class AppUrl {
  int id;
  String androidUrl;
  String isoUrl;
  DateTime createdAt;
  DateTime updatedAt;

  AppUrl({
    required this.id,
    required this.androidUrl,
    required this.isoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUrl.fromJson(Map<String, dynamic> json) => AppUrl(
        id: json["id"],
        androidUrl: json["android_url"],
        isoUrl: json["iso_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "android_url": androidUrl,
        "iso_url": isoUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class BasicSettingsData {
  String siteName;
  String siteTitle;
  String baseColor;
  String timezone;
  bool userRegistration;
  bool emailVerification;
  bool emailNotification;
  bool pushNotification;
  bool kycVerification;
  dynamic fiatPrecisionValue;
  dynamic cryptoPrecisionValue;

  BasicSettingsData({
    required this.siteName,
    required this.siteTitle,
    required this.baseColor,
    required this.timezone,
    required this.userRegistration,
    required this.emailVerification,
    required this.emailNotification,
    required this.pushNotification,
    required this.kycVerification,
    required this.fiatPrecisionValue,
    required this.cryptoPrecisionValue,
  });

  factory BasicSettingsData.fromJson(Map<String, dynamic> json) =>
      BasicSettingsData(
        siteName: json["site_name"],
        siteTitle: json["site_title"],
        baseColor: json["base_color"],
        timezone: json["timezone"],
        userRegistration: json["user_registration"],
        emailVerification: json["email_verification"],
        emailNotification: json["email_notification"],
        pushNotification: json["push_notification"],
        kycVerification: json["kyc_verification"],
        fiatPrecisionValue: json["fiat_precision_value"] ?? 0,
        cryptoPrecisionValue: json["crypto_precision_value"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "site_name": siteName,
        "site_title": siteTitle,
        "base_color": baseColor,
        "timezone": timezone,
        "user_registration": userRegistration,
        "email_verification": emailVerification,
        "email_notification": emailNotification,
        "push_notification": pushNotification,
        "kyc_verification": kycVerification,
        "fiat_precision_value": fiatPrecisionValue,
        "crypto_precision_value": cryptoPrecisionValue,
      };
}

class OnboardScreen {
  int id;
  String title;
  String subTitle;
  String image;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  OnboardScreen({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardScreen.fromJson(Map<String, dynamic> json) => OnboardScreen(
        id: json["id"],
        title: json["title"],
        subTitle: json["sub_title"],
        image: json["image"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "sub_title": subTitle,
        "image": image,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class SplashScreen {
  int id;
  String splashScreenImage;
  String version;
  DateTime createdAt;
  DateTime updatedAt;

  SplashScreen({
    required this.id,
    required this.splashScreenImage,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SplashScreen.fromJson(Map<String, dynamic> json) => SplashScreen(
        id: json["id"],
        splashScreenImage: json["splash_screen_image"],
        version: json["version"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "splash_screen_image": splashScreenImage,
        "version": version,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Message {
  List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
