// Safe JSON coercion helpers shared by every fromJson below. A freshly
// created ("processing") card, or a user who hasn't completed KYC yet, gets
// null back for fields the API otherwise always fills in (card_number,
// expiry, cvv, card_back_details, site_*, nested objects, …). Parsing those
// directly as non-nullable String/int/Map previously threw
// "type 'Null' is not a subtype of type 'String'" and crashed the whole
// card-info fetch right after buying a card.
String _s(dynamic v, [String fallback = '']) {
  if (v == null) return fallback;
  return v is String ? v : v.toString();
}

int _i(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

Map<String, dynamic> _m(dynamic v) => v is Map<String, dynamic> ? v : const {};

List _l(dynamic v) => v is List ? v : const [];

class StrowalletCardModel {
  Message message;
  Data data;

  StrowalletCardModel({
    required this.message,
    required this.data,
  });

  factory StrowalletCardModel.fromJson(Map<String, dynamic> json) =>
      StrowalletCardModel(
        message: Message.fromJson(_m(json["message"])),
        data: Data.fromJson(_m(json["data"])),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String baseCurr;
  int baseCurrRate;
  GetRemainingFields getRemainingFields;
  List<SupportedCurrency> supportedCurrency;
  bool cardCreateAction;
  bool strowalletCustomerInfo;
  CardBasicInfo cardBasicInfo;
  List<MyCard> myCards;
  User user;
  List<UserWallet> userWallet;
  CardCharge cardCharge;
  List<dynamic> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.getRemainingFields,
    required this.supportedCurrency,
    required this.cardCreateAction,
    required this.strowalletCustomerInfo,
    required this.cardBasicInfo,
    required this.myCards,
    required this.user,
    required this.userWallet,
    required this.cardCharge,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: _s(json["base_curr"]),
        baseCurrRate: _i(json["base_curr_rate"]),
        getRemainingFields:
            GetRemainingFields.fromJson(_m(json["get_remaining_fields"])),
        supportedCurrency: List<SupportedCurrency>.from(_l(
                json["supported_currency"])
            .map((x) => SupportedCurrency.fromJson(_m(x)))),
        cardCreateAction: json["card_create_action"] ?? false,
        // API field is `strowallet_customer_status` — reading the old
        // `strowallet_customer_info` key returned null and threw
        // "type 'Null' is not a subtype of type 'bool'".
        strowalletCustomerInfo: json["strowallet_customer_status"] ?? false,
        cardBasicInfo: CardBasicInfo.fromJson(_m(json["card_basic_info"])),
        myCards: List<MyCard>.from(
            _l(json["myCards"]).map((x) => MyCard.fromJson(_m(x)))),
        user: User.fromJson(_m(json["user"])),
        userWallet: List<UserWallet>.from(
            _l(json["userWallet"]).map((x) => UserWallet.fromJson(_m(x)))),
        cardCharge: CardCharge.fromJson(_m(json["cardCharge"])),
        transactions: List<dynamic>.from(_l(json["transactions"])),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),
        "supported_currency":
            List<dynamic>.from(supportedCurrency.map((x) => x.toJson())),
        "card_create_action": cardCreateAction,
        "strowallet_customer_info": strowalletCustomerInfo,
        "card_basic_info": cardBasicInfo.toJson(),
        "myCards": List<dynamic>.from(myCards.map((x) => x.toJson())),
        "user": user.toJson(),
        "userWallet": List<dynamic>.from(userWallet.map((x) => x.toJson())),
        "cardCharge": cardCharge.toJson(),
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
      };
}

class MyCard {
  int id;
  String name;
  String cardNumber;
  String cardId;
  String expiry;
  String cvv;
  int balance;
  String cardStatus;
  String cardBackDetails;
  String siteTitle;
  String siteLogo;
  String siteFav;
  bool status;
  bool isDefault;
  MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.name,
    required this.cardNumber,
    required this.cardId,
    required this.expiry,
    required this.cvv,
    required this.balance,
    required this.cardStatus,
    required this.cardBackDetails,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
    required this.status,
    required this.isDefault,
    required this.statusInfo,
  });

  // A newly created card sitting in "processing" has not been issued a
  // number/expiry/cvv yet — the API returns null for those until the card
  // provider finishes provisioning. Every field here defaults safely instead
  // of crashing, so the "My Cards" list can still render the processing card.
  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
        id: _i(json["id"]),
        name: _s(json["name"]),
        cardNumber: _s(json["card_number"]),
        cardId: _s(json["card_id"]),
        expiry: _s(json["expiry"]),
        cvv: _s(json["cvv"]),
        balance: _i(json["balance"]),
        cardStatus: _s(json["card_status"]),
        cardBackDetails: _s(json["card_back_details"]),
        siteTitle: _s(json["site_title"]),
        siteLogo: _s(json["site_logo"]),
        siteFav: _s(json["site_fav"]),
        status: json["status"] ?? false,
        isDefault: json["is_default"] ?? false,
        statusInfo: MyCardStatusInfo.fromJson(_m(json["status_info"])),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "card_number": cardNumber,
        "card_id": cardId,
        "expiry": expiry,
        "cvv": cvv,
        "balance": balance,
        "card_status": cardStatus,
        "card_back_details": cardBackDetails,
        "site_title": siteTitle,
        "site_logo": siteLogo,
        "site_fav": siteFav,
        "status": status,
        "is_default": isDefault,
        "status_info": statusInfo.toJson(),
      };
}

class MyCardStatusInfo {
  int block;
  int unblock;

  MyCardStatusInfo({
    required this.block,
    required this.unblock,
  });

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) =>
      MyCardStatusInfo(
        block: _i(json["block"]),
        unblock: _i(json["unblock"]),
      );

  Map<String, dynamic> toJson() => {
        "block": block,
        "unblock": unblock,
      };
}

class CardBasicInfo {
  int cardCreateLimit;
  String cardBackDetails;
  String cardBg;
  String siteTitle;
  String siteLogo;
  String siteFav;

  CardBasicInfo({
    required this.cardCreateLimit,
    required this.cardBackDetails,
    required this.cardBg,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
  });

  factory CardBasicInfo.fromJson(Map<String, dynamic> json) => CardBasicInfo(
        cardCreateLimit: _i(json["card_create_limit"]),
        cardBackDetails: _s(json["card_back_details"]),
        cardBg: _s(json["card_bg"]),
        siteTitle: _s(json["site_title"]),
        siteLogo: _s(json["site_logo"]),
        siteFav: _s(json["site_fav"]),
      );

  Map<String, dynamic> toJson() => {
        "card_create_limit": cardCreateLimit,
        "card_back_details": cardBackDetails,
        "card_bg": cardBg,
        "site_title": siteTitle,
        "site_logo": siteLogo,
        "site_fav": siteFav,
      };
}

class CardCharge {
  int id;
  String slug;
  String title;
  int fixedCharge;
  int percentCharge;
  int minLimit;
  int maxLimit;
  int dailyLimit;
  int monthlyLimit;

  CardCharge({
    required this.id,
    required this.slug,
    required this.title,
    required this.fixedCharge,
    required this.percentCharge,
    required this.minLimit,
    required this.maxLimit,
    required this.dailyLimit,
    required this.monthlyLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
        id: _i(json["id"]),
        slug: _s(json["slug"]),
        title: _s(json["title"]),
        fixedCharge: _i(json["fixed_charge"]),
        percentCharge: _i(json["percent_charge"]),
        minLimit: _i(json["min_limit"]),
        maxLimit: _i(json["max_limit"]),
        dailyLimit: _i(json["daily_limit"]),
        monthlyLimit: _i(json["monthly_limit"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "daily_limit": dailyLimit,
        "monthly_limit": monthlyLimit,
      };
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({
    required this.transactionType,
    required this.attribute,
  });

  factory GetRemainingFields.fromJson(Map<String, dynamic> json) =>
      GetRemainingFields(
        transactionType: _s(json["transaction_type"]),
        attribute: _s(json["attribute"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "attribute": attribute,
      };
}

class SupportedCurrency {
  int id;
  String name;
  String mobileCode;
  String currencyName;
  String currencyCode;
  String currencySymbol;
  int rate;
  int status;

  SupportedCurrency({
    required this.id,
    required this.name,
    required this.mobileCode,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.rate,
    required this.status,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) =>
      SupportedCurrency(
        id: _i(json["id"]),
        name: _s(json["name"]),
        mobileCode: _s(json["mobile_code"]),
        currencyName: _s(json["currency_name"]),
        currencyCode: _s(json["currency_code"]),
        currencySymbol: _s(json["currency_symbol"]),
        rate: _i(json["rate"]),
        status: _i(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile_code": mobileCode,
        "currency_name": currencyName,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "rate": rate,
        "status": status,
      };
}

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String? mobileCode;
  String mobile;
  String fullMobile;
  dynamic refferalUserId;
  dynamic image;
  int status;
  Address address;
  int emailVerified;
  int smsVerified;
  int kycVerified;
  dynamic verCode;
  dynamic verCodeSendAt;
  int twoFactorVerified;
  dynamic deviceId;
  dynamic emailVerifiedAt;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic sudoCustomer;
  dynamic sudoAccount;
  dynamic strowalletCustomer;
  dynamic stripeCardHolders;
  dynamic stripeConnectedAccount;
  int twoFactorStatus;
  dynamic twoFactorSecret;
  String fullname;
  String userImage;
  Status stringStatus;
  Status emailStatus;
  String lastLogin;
  Status kycStringStatus;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
     this.mobileCode,
    required this.mobile,
    required this.fullMobile,
    required this.refferalUserId,
    required this.image,
    required this.status,
    required this.address,
    required this.emailVerified,
    required this.smsVerified,
    required this.kycVerified,
    required this.verCode,
    required this.verCodeSendAt,
    required this.twoFactorVerified,
    required this.deviceId,
    required this.emailVerifiedAt,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.sudoCustomer,
    required this.sudoAccount,
    required this.strowalletCustomer,
    required this.stripeCardHolders,
    required this.stripeConnectedAccount,
    required this.twoFactorStatus,
    required this.twoFactorSecret,
    required this.fullname,
    required this.userImage,
    required this.stringStatus,
    required this.emailStatus,
    required this.lastLogin,
    required this.kycStringStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: _i(json["id"]),
        firstname: _s(json["firstname"]),
        lastname: _s(json["lastname"]),
        username: _s(json["username"]),
        email: _s(json["email"]),
        mobileCode: json["mobile_code"] ?? '',
        // New users have no phone yet → these arrive null; parsing them as
        // non-null String threw "type 'Null' is not a subtype of String" and
        // surfaced as the dashboard "Something went Wrong!" snackbar.
        mobile: json["mobile"] ?? '',
        fullMobile: json["full_mobile"] ?? '',
        refferalUserId: json["refferal_user_id"],
        image: json["image"],
        status: _i(json["status"]),
        // Accounts that never set an address get address: null (not an empty
        // object) — parsing it crashed the strowallet card fetch and popped
        // "Something went Wrong!" on the dashboard.
        address: Address.fromJson(_m(json["address"])),
        emailVerified: _i(json["email_verified"]),
        smsVerified: _i(json["sms_verified"]),
        kycVerified: _i(json["kyc_verified"]),
        verCode: json["ver_code"],
        verCodeSendAt: json["ver_code_send_at"],
        twoFactorVerified: _i(json["two_factor_verified"]),
        deviceId: json["device_id"],
        emailVerifiedAt: json["email_verified_at"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.tryParse(_s(json["created_at"])) ?? DateTime.now(),
        updatedAt: DateTime.tryParse(_s(json["updated_at"])) ?? DateTime.now(),
        sudoCustomer: json["sudo_customer"],
        sudoAccount: json["sudo_account"],
        strowalletCustomer: json["strowallet_customer"],
        stripeCardHolders: json["stripe_card_holders"],
        stripeConnectedAccount: json["stripe_connected_account"],
        twoFactorStatus: _i(json["two_factor_status"]),
        twoFactorSecret: json["two_factor_secret"],
        fullname: _s(json["fullname"]),
        userImage: _s(json["userImage"]),
        stringStatus: Status.fromJson(_m(json["stringStatus"])),
        emailStatus: Status.fromJson(_m(json["emailStatus"])),
        lastLogin: _s(json["lastLogin"]),
        kycStringStatus: Status.fromJson(_m(json["kycStringStatus"])),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "mobile_code": mobileCode ?? '',
        "mobile": mobile,
        "full_mobile": fullMobile,
        "refferal_user_id": refferalUserId,
        "image": image,
        "status": status,
        "address": address.toJson(),
        "email_verified": emailVerified,
        "sms_verified": smsVerified,
        "kyc_verified": kycVerified,
        "ver_code": verCode,
        "ver_code_send_at": verCodeSendAt,
        "two_factor_verified": twoFactorVerified,
        "device_id": deviceId,
        "email_verified_at": emailVerifiedAt,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sudo_customer": sudoCustomer,
        "sudo_account": sudoAccount,
        "strowallet_customer": strowalletCustomer,
        "stripe_card_holders": stripeCardHolders,
        "stripe_connected_account": stripeConnectedAccount,
        "two_factor_status": twoFactorStatus,
        "two_factor_secret": twoFactorSecret,
        "fullname": fullname,
        "userImage": userImage,
        "stringStatus": stringStatus.toJson(),
        "emailStatus": emailStatus.toJson(),
        "lastLogin": lastLogin,
        "kycStringStatus": kycStringStatus.toJson(),
      };
}

class Address {
  String country;
  String state;
  String city;
  String zip;
  String address;

  Address({
    required this.country,
    required this.state,
    required this.city,
    required this.zip,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        country: json["country"] ?? '',
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        zip: json["zip"] ?? '',
        address: json["address"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "state": state,
        "city": city,
        "zip": zip,
        "address": address,
      };
}

class Status {
  String statusClass;
  String value;

  Status({
    required this.statusClass,
    required this.value,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        statusClass: _s(json["class"]),
        value: _s(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "class": statusClass,
        "value": value,
      };
}

class UserWallet {
  dynamic balance;
  int status;
  Currency currency;

  UserWallet({
    required this.balance,
    required this.status,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: json["balance"],
        status: _i(json["status"]),
        currency: Currency.fromJson(_m(json["currency"])),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "status": status,
        "currency": currency.toJson(),
      };
}

class Currency {
  String code;
  int rate;
  String flag;
  String symbol;
  String type;
  int currencyDefault;
  String country;
  String name;
  bool both;
  bool senderCurrency;
  bool receiverCurrency;

  Currency({
    required this.code,
    required this.rate,
    required this.flag,
    required this.symbol,
    required this.type,
    required this.currencyDefault,
    required this.country,
    required this.name,
    required this.both,
    required this.senderCurrency,
    required this.receiverCurrency,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        code: _s(json["code"]),
        rate: _i(json["rate"]),
        flag: _s(json["flag"]),
        symbol: _s(json["symbol"]),
        type: _s(json["type"]),
        currencyDefault: _i(json["default"]),
        country: _s(json["country"]),
        name: _s(json["name"]),
        both: json["both"] ?? false,
        senderCurrency: json["senderCurrency"] ?? false,
        receiverCurrency: json["receiverCurrency"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "rate": rate,
        "flag": flag,
        "symbol": symbol,
        "type": type,
        "default": currencyDefault,
        "country": country,
        "name": name,
        "both": both,
        "senderCurrency": senderCurrency,
        "receiverCurrency": receiverCurrency,
      };
}

class Message {
  List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success:
            List<String>.from(_l(json["success"]).map((x) => _s(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
