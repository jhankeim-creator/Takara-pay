// To parse this JSON data, do
//
//     final myCardCardyfieModel = myCardCardyfieModelFromJson(jsonString);

// this is main model

import 'dart:ffi';

import 'package:meta/meta.dart';
import 'dart:convert';

import "package:TAKARA PAY/base/widgets/dropdown/cardyfie_wallet_card_dropdown.dart";

MyCardCardyfieModel myCardCardyfieModelFromJson(String str) =>
    MyCardCardyfieModel.fromJson(json.decode(str));

String myCardCardyfieModelToJson(MyCardCardyfieModel data) =>
    json.encode(data.toJson());

class MyCardCardyfieModel {
  Message message;
  Data data;

  MyCardCardyfieModel({required this.message, required this.data});

  factory MyCardCardyfieModel.fromJson(Map<String, dynamic> json) =>
      MyCardCardyfieModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String baseCurr;
  dynamic baseCurrRate;
  GetRemainingFields getRemainingFields;
  List<SupportedCurrency> supportedCurrency;
  bool cardCreateAction;
  bool customerCreateStatus;
  CardBasicInfo cardBasicInfo;
  List<MyCard>? myCards;
  // User user;
  List<UserWallet> userWallet;
  CardCharge cardCharge;
  // List<Transaction> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.getRemainingFields,
    required this.supportedCurrency,
    required this.cardCreateAction,
    required this.customerCreateStatus,
    required this.cardBasicInfo,
    this.myCards,
    // required this.user,
    required this.userWallet,
    required this.cardCharge,
    // required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    baseCurr: json["base_curr"],
    baseCurrRate: json["base_curr_rate"],
    getRemainingFields: GetRemainingFields.fromJson(
      json["get_remaining_fields"],
    ),
    supportedCurrency: List<SupportedCurrency>.from(
      json["supported_currency"].map((x) => SupportedCurrency.fromJson(x)),
    ),
    cardCreateAction: json["card_create_action"] ?? false,
    customerCreateStatus: json["customer_create_status"] ?? false,
    cardBasicInfo: CardBasicInfo.fromJson(json["card_basic_info"]),
    myCards: (json['myCards'] != null && json['myCards'] is List)
        ? List<MyCard>.from(json['myCards'].map((x) => MyCard.fromJson(x)))
        : [], // ✅ Safe for new users
    // user: User.fromJson(json["user"]),
    userWallet: List<UserWallet>.from(
      json["userWallet"].map((x) => UserWallet.fromJson(x)),
    ),
    cardCharge: CardCharge.fromJson(json["cardCharge"]),
    // transactions: List<Transaction>.from(
    //   json["transactions"].map((x) => Transaction.fromJson(x)),
    // ),
  );

  Map<String, dynamic> toJson() => {
    "base_curr": baseCurr,
    "base_curr_rate": baseCurrRate,
    "get_remaining_fields": getRemainingFields.toJson(),
    "supported_currency": List<dynamic>.from(
      supportedCurrency.map((x) => x.toJson()),
    ),
    "card_create_action": cardCreateAction,
    "customer_create_status": customerCreateStatus,
    "card_basic_info": cardBasicInfo.toJson(),
    "myCards": myCards != null
        ? List<dynamic>.from(myCards!.map((x) => x.toJson()))
        : [], // ✅ Safe for new users
    // "user": user.toJson(),
    "userWallet": List<dynamic>.from(userWallet.map((x) => x.toJson())),
    "cardCharge": cardCharge.toJson(),
    // "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
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
    cardCreateLimit: json["card_create_limit"] ?? 0,
    cardBackDetails: json["card_back_details"],
    cardBg: json["card_bg"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    siteFav: json["site_fav"],
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
  dynamic universalCardIssuesFee;
  dynamic platinumCardIssuesFee;
  dynamic cardDepositFixedFee;
  dynamic cardWithdrawFixedFee;
  dynamic cardMaintenanceFixedFee;
  dynamic minLimit;
  dynamic maxLimit;
  dynamic dailyLimit;
  dynamic monthlyLimit;

  CardCharge({
    required this.universalCardIssuesFee,
    required this.platinumCardIssuesFee,
    required this.cardDepositFixedFee,
    required this.cardWithdrawFixedFee,
    required this.cardMaintenanceFixedFee,
    required this.minLimit,
    required this.maxLimit,
    required this.dailyLimit,
    required this.monthlyLimit,
  });

  factory CardCharge.fromJson(Map<String, dynamic> json) => CardCharge(
    universalCardIssuesFee: json["universal_card_issues_fee"],
    platinumCardIssuesFee: json["platinum_card_issues_fee"],
    cardDepositFixedFee: json["card_deposit_fixed_fee"],
    cardWithdrawFixedFee: json["card_withdraw_fixed_fee"],
    cardMaintenanceFixedFee: json["card_maintenance_fixed_fee"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    dailyLimit: json["daily_limit"],
    monthlyLimit: json["monthly_limit"],
  );

  Map<String, dynamic> toJson() => {
    "universal_card_issues_fee": universalCardIssuesFee,
    "platinum_card_issues_fee": platinumCardIssuesFee,
    "card_deposit_fixed_fee": cardDepositFixedFee,
    "card_withdraw_fixed_fee": cardWithdrawFixedFee,
    "card_maintenance_fixed_fee": cardMaintenanceFixedFee,
    "min_limit": minLimit,
    "max_limit": maxLimit,
    "daily_limit": dailyLimit,
    "monthly_limit": monthlyLimit,
  };
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({required this.transactionType, required this.attribute});

  factory GetRemainingFields.fromJson(Map<String, dynamic> json) =>
      GetRemainingFields(
        transactionType: json["transaction_type"],
        attribute: json["attribute"],
      );

  Map<String, dynamic> toJson() => {
    "transaction_type": transactionType,
    "attribute": attribute,
  };
}

class MyCard {
  int id;
  String referenceId;
  String ulid;
  String customerUlid;
  String cardName;
  dynamic amount;
  String currency;
  String cardTier;
  String cardType;
  String cardExpTime;
  String maskedPan;
  String address;
  String status;
  String env;
  bool isDefault;
  MyCardStatusInfo statusInfo;

  MyCard({
    required this.id,
    required this.referenceId,
    required this.ulid,
    required this.customerUlid,
    required this.cardName,
    required this.amount,
    required this.currency,
    required this.cardTier,
    required this.cardType,
    required this.cardExpTime,
    required this.maskedPan,
    required this.address,
    required this.status,
    required this.env,
    required this.isDefault,
    required this.statusInfo,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
    id: json["id"],
    referenceId: json["reference_id"],
    ulid: json["ulid"],
    customerUlid: json["customer_ulid"],
    cardName: json["card_name"],
    amount: json["amount"],
    currency: json["currency"],
    cardTier: json["card_tier"],
    cardType: json["card_type"],
    cardExpTime: json["card_exp_time"],
    maskedPan: json["masked_pan"],
    address: json["address"],
    status: json["status"],
    env: json["env"],
    isDefault: json["is_default"] ?? false,
    statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_id": referenceId,
    "ulid": ulid,
    "customer_ulid": customerUlid,
    "card_name": cardName,
    "amount": amount,
    "currency": currency,
    "card_tier": cardTier,
    "card_type": cardType,
    "card_exp_time": cardExpTime,
    "masked_pan": maskedPan,
    "address": address,
    "status": status,
    "env": env,
    "is_default": isDefault,
    "status_info": statusInfo.toJson(),
  };
}

class MyCardStatusInfo {
  String processing;
  String enabled;
  String freeze;
  String closed;

  MyCardStatusInfo({
    required this.processing,
    required this.enabled,
    required this.freeze,
    required this.closed,
  });

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) =>
      MyCardStatusInfo(
        processing: json["PROCESSING"],
        enabled: json["ENABLED"],
        freeze: json["FREEZE"],
        closed: json["CLOSED"],
      );

  Map<String, dynamic> toJson() => {
    "PROCESSING": processing,
    "ENABLED": enabled,
    "FREEZE": freeze,
    "CLOSED": closed,
  };
}

class SupportedCurrency implements DropdownModel {
  int id;
  String name;
  String mobileCode;
  String currencyName;
  String currencyCode;
  String currencySymbol;
  dynamic rate;
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
        id: json["id"],
        name: json["name"],
        mobileCode: json["mobile_code"],
        currencyName: json["currency_name"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        rate: json["rate"],
        status: json["status"],
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

  @override
  String get title => currencyCode;
}

class Transaction {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String totalCharge;
  String cardAmount;
  String cardNumber;
  String currentBalance;
  String status;
  DateTime dateTime;
  TransactionStatusInfo statusInfo;

  Transaction({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    totalCharge: json["total_charge"],
    cardAmount: json["card_amount"],
    cardNumber: json["card_number"],
    currentBalance: json["current_balance"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: TransactionStatusInfo.fromJson(json["status_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trx": trx,
    "transaction_type": transactionType,
    "request_amount": requestAmount,
    "payable": payable,
    "total_charge": totalCharge,
    "card_amount": cardAmount,
    "card_number": cardNumber,
    "current_balance": currentBalance,
    "status": status,
    "date_time": dateTime.toIso8601String(),
    "status_info": statusInfo.toJson(),
  };
}

class TransactionStatusInfo {
  int success;
  int pending;
  int rejected;

  TransactionStatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory TransactionStatusInfo.fromJson(Map<String, dynamic> json) =>
      TransactionStatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "pending": pending,
    "rejected": rejected,
  };
}

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  dynamic mobileCode;
  dynamic mobile;
  dynamic fullMobile;
  dynamic refferalUserId;
  dynamic image;
  int status;
  Address? address;
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
  dynamic stripeTestCardHolder;
  dynamic stripeConnectedAccount;
  dynamic stripeFinancialAccount;
  int twoFactorStatus;
  dynamic twoFactorSecret;
  String fullname;
  String userImage;
  Status stringStatus;
  Status emailStatus;
  String lastLogin;
  Status kycStringStatus;
  // CardyfieCardCustomer cardyfieCardCustomer;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.mobileCode,
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
    required this.stripeTestCardHolder,
    required this.stripeConnectedAccount,
    required this.stripeFinancialAccount,
    required this.twoFactorStatus,
    required this.twoFactorSecret,
    required this.fullname,
    required this.userImage,
    required this.stringStatus,
    required this.emailStatus,
    required this.lastLogin,
    required this.kycStringStatus,
    // required this.cardyfieCardCustomer,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    email: json["email"],
    mobileCode: json["mobile_code"],
    mobile: json["mobile"],
    fullMobile: json["full_mobile"],
    refferalUserId: json["refferal_user_id"],
    image: json["image"],
    status: json["status"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    emailVerified: json["email_verified"],
    smsVerified: json["sms_verified"],
    kycVerified: json["kyc_verified"],
    verCode: json["ver_code"],
    verCodeSendAt: json["ver_code_send_at"],
    twoFactorVerified: json["two_factor_verified"],
    deviceId: json["device_id"],
    emailVerifiedAt: json["email_verified_at"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    sudoCustomer: json["sudo_customer"],
    sudoAccount: json["sudo_account"],
    strowalletCustomer: json["strowallet_customer"],
    stripeCardHolders: json["stripe_card_holders"],
    stripeTestCardHolder: json["stripe_test_card_holder"],
    stripeConnectedAccount: json["stripe_connected_account"],
    stripeFinancialAccount: json["stripe_financial_account"],
    twoFactorStatus: json["two_factor_status"],
    twoFactorSecret: json["two_factor_secret"],
    fullname: json["fullname"],
    userImage: json["userImage"],
    stringStatus: Status.fromJson(json["stringStatus"]),
    emailStatus: Status.fromJson(json["emailStatus"]),
    lastLogin: json["lastLogin"],
    kycStringStatus: Status.fromJson(json["kycStringStatus"]),
    // cardyfieCardCustomer: CardyfieCardCustomer.fromJson(
    //   json["cardyfie_card_customer"],
    // ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "mobile_code": mobileCode,
    "mobile": mobile,
    "full_mobile": fullMobile,
    "refferal_user_id": refferalUserId,
    "image": image,
    "status": status,
    "address": address?.toJson(),
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
    "stripe_test_card_holder": stripeTestCardHolder,
    "stripe_connected_account": stripeConnectedAccount,
    "stripe_financial_account": stripeFinancialAccount,
    "two_factor_status": twoFactorStatus,
    "two_factor_secret": twoFactorSecret,
    "fullname": fullname,
    "userImage": userImage,
    "stringStatus": stringStatus.toJson(),
    "emailStatus": emailStatus.toJson(),
    "lastLogin": lastLogin,
    "kycStringStatus": kycStringStatus.toJson(),
    // "cardyfie_card_customer": cardyfieCardCustomer.toJson(),
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
    country: json["country"] ?? "",
    state: json["state"] ?? "",
    city: json["city"] ?? "",
    zip: json["zip"] ?? "",
    address: json["address"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "state": state,
    "city": city,
    "zip": zip,
    "address": address,
  };
}

// class CardyfieCardCustomer {
//   int id;
//   String userType;
//   int userId;
//   String ulid;
//   String referenceId;
//   String firstName;
//   String lastName;
//   String email;
//   // DateTime dateOfBirth;
//   String idType;
//   String idNumber;
//   String? idFrontImage;
//   String cardyfieCardCustomerIdBackImage;
//   String cardyfieCardCustomerUserImage;
//   String houseNumber;
//   String addressLine1;
//   String city;
//   String state;
//   String zipCode;
//   String country;
//   String status;
//   dynamic meta;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String idFontImage;
//   String idBackImage;
//   String userImage;

//   CardyfieCardCustomer({
//     required this.id,
//     required this.userType,
//     required this.userId,
//     required this.ulid,
//     required this.referenceId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     // required this.dateOfBirth,
//     required this.idType,
//     required this.idNumber,
//     this.idFrontImage,
//     required this.cardyfieCardCustomerIdBackImage,
//     required this.cardyfieCardCustomerUserImage,
//     required this.houseNumber,
//     required this.addressLine1,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.country,
//     required this.status,
//     required this.meta,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.idFontImage,
//     required this.idBackImage,
//     required this.userImage,
//   });

//   factory CardyfieCardCustomer.fromJson(Map<String, dynamic> json) =>
//       CardyfieCardCustomer(
//         id: json["id"],
//         userType: json["user_type"],
//         userId: json["user_id"],
//         ulid: json["ulid"],
//         referenceId: json["reference_id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         email: json["email"],
//         // dateOfBirth: DateTime.parse(json["date_of_birth"]) ,
//         idType: json["id_type"],
//         idNumber: json["id_number"],
//         idFrontImage: json["id_front_image"] ?? "",
//         cardyfieCardCustomerIdBackImage: json["id_back_image"],
//         cardyfieCardCustomerUserImage: json["user_image"],
//         houseNumber: json["house_number"],
//         addressLine1: json["address_line_1"],
//         city: json["city"],
//         state: json["state"],
//         zipCode: json["zip_code"],
//         country: json["country"],
//         status: json["status"],
//         meta: json["meta"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         idFontImage: json["idFontImage"],
//         idBackImage: json["idBackImage"],
//         userImage: json["userImage"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_type": userType,
//     "user_id": userId,
//     "ulid": ulid,
//     "reference_id": referenceId,
//     "first_name": firstName,
//     "last_name": lastName,
//     "email": email,
//     // "date_of_birth":
//     //     "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
//     "id_type": idType,
//     "id_number": idNumber,
//     "id_front_image": idFrontImage ?? '',
//     "id_back_image": cardyfieCardCustomerIdBackImage,
//     "user_image": cardyfieCardCustomerUserImage,
//     "house_number": houseNumber,
//     "address_line_1": addressLine1,
//     "city": city,
//     "state": state,
//     "zip_code": zipCode,
//     "country": country,
//     "status": status,
//     "meta": meta,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "idFontImage": idFontImage,
//     "idBackImage": idBackImage,
//     "userImage": userImage,
//   };
// }

// class CardyfieCardCustomer {
//   int id;
//   String userType;
//   int userId;
//   String ulid;
//   String referenceId;
//   String firstName;
//   String lastName;
//   String email;
//   // DateTime dateOfBirth;
//   String idType;
//   String idNumber;
//   String idFrontImage;
//   String cardyfieCardCustomerIdBackImage;
//   String cardyfieCardCustomerUserImage;
//   String houseNumber;
//   String addressLine1;
//   String city;
//   String state;
//   String zipCode;
//   String country;
//   String status;
//   dynamic meta;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String idFontImage;
//   String idBackImage;
//   String userImage;

//   CardyfieCardCustomer({
//     required this.id,
//     required this.userType,
//     required this.userId,
//     required this.ulid,
//     required this.referenceId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     // required this.dateOfBirth,
//     required this.idType,
//     required this.idNumber,
//      this.idFrontImage,
//     required this.cardyfieCardCustomerIdBackImage,
//     required this.cardyfieCardCustomerUserImage,
//     required this.houseNumber,
//     required this.addressLine1,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.country,
//     required this.status,
//     required this.meta,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.idFontImage,
//     required this.idBackImage,
//     required this.userImage,
//   });

//   factory CardyfieCardCustomer.fromJson(Map<String, dynamic> json) =>
//       CardyfieCardCustomer(
//         id: json["id"],
//         userType: json["user_type"],
//         userId: json["user_id"],
//         ulid: json["ulid"],
//         referenceId: json["reference_id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         email: json["email"],
//         // dateOfBirth: DateTime.parse(json["date_of_birth"]),
//         idType: json["id_type"],
//         idNumber: json["id_number"],
//         idFrontImage: json["id_front_image"],
//         cardyfieCardCustomerIdBackImage: json["id_back_image"],
//         cardyfieCardCustomerUserImage: json["user_image"],
//         houseNumber: json["house_number"],
//         addressLine1: json["address_line_1"],
//         city: json["city"],
//         state: json["state"],
//         zipCode: json["zip_code"],
//         country: json["country"],
//         status: json["status"],
//         meta: json["meta"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         idFontImage: json["idFontImage"],
//         idBackImage: json["idBackImage"],
//         userImage: json["userImage"],
//       );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_type": userType,
//     "user_id": userId,
//     "ulid": ulid,
//     "reference_id": referenceId,
//     "first_name": firstName,
//     "last_name": lastName,
//     "email": email,
//     // "date_of_birth":
//     //     "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
//     "id_type": idType,
//     "id_number": idNumber,
//     "id_front_image": idFrontImage,
//     "id_back_image": cardyfieCardCustomerIdBackImage,
//     "user_image": cardyfieCardCustomerUserImage,
//     "house_number": houseNumber,
//     "address_line_1": addressLine1,
//     "city": city,
//     "state": state,
//     "zip_code": zipCode,
//     "country": country,
//     "status": status,
//     "meta": meta,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "idFontImage": idFontImage,
//     "idBackImage": idBackImage,
//     "userImage": userImage,
//   };
// }

class Status {
  String statusClass;
  String value;

  Status({required this.statusClass, required this.value});

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(statusClass: json["class"], value: json["value"]);

  Map<String, dynamic> toJson() => {"class": statusClass, "value": value};
}

class UserWallet implements DropdownModel {
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
    status: json["status"],
    currency: Currency.fromJson(json["currency"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "status": status,
    "currency": currency.toJson(),
  };

  @override
  String get title =>
      "${currency.country} (${double.parse(balance.toString()).toStringAsFixed(2)} ${currency.code})";
}

class Currency {
  String code;
  dynamic rate;
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
    code: json["code"],
    rate: json["rate"],
    flag: json["flag"],
    symbol: json["symbol"],
    type: json["type"],
    currencyDefault: json["default"],
    country: json["country"],
    name: json["name"],
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

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x)),
  };
}
