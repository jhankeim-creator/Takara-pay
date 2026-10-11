// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) =>
    DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  Message message;
  Data data;

  DashBoardModel({required this.message, required this.data});

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String defaultImage;
  String imagePath;
  PusherCredentials pusherCredentials;
  ModuleAccess moduleAccess;
  User user;
  String baseCurr;
  List<UserWallet> userWallet;
  String activeVirtualSystem;
  CardCharge cardCreateCharge;
  CardCharge cardReloadCharge;
  String totalAddMoney;
  String totalTransactions;
  int activeCards;
  List<Transaction> transactions;

  Data({
    required this.defaultImage,
    required this.imagePath,
    required this.pusherCredentials,
    required this.moduleAccess,
    required this.user,
    required this.baseCurr,
    required this.userWallet,
    required this.activeVirtualSystem,
    required this.cardCreateCharge,
    required this.cardReloadCharge,
    required this.totalAddMoney,
    required this.totalTransactions,
    required this.activeCards,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    defaultImage: json["default_image"],
    imagePath: json["image_path"],
    pusherCredentials: PusherCredentials.fromJson(json["pusher_credentials"]),
    moduleAccess: ModuleAccess.fromJson(json["module_access"]),
    user: User.fromJson(json["user"]),
    baseCurr: json["base_curr"],
    userWallet: List<UserWallet>.from(
      json["userWallet"].map((x) => UserWallet.fromJson(x)),
    ),
    activeVirtualSystem: json["active_virtual_system"],
    cardCreateCharge: CardCharge.fromJson(json["card_create_charge"]),
    cardReloadCharge: CardCharge.fromJson(json["card_reload_charge"]),
    totalAddMoney: json["totalAddMoney"],
    totalTransactions: json["totalTransactions"],
    activeCards: json["active_cards"],
    transactions: List<Transaction>.from(
      json["transactions"].map((x) => Transaction.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "default_image": defaultImage,
    "image_path": imagePath,
    "pusher_credentials": pusherCredentials.toJson(),
    "module_access": moduleAccess.toJson(),
    "user": user.toJson(),
    "base_curr": baseCurr,
    "userWallet": List<dynamic>.from(userWallet.map((x) => x.toJson())),
    "active_virtual_system": activeVirtualSystem,
    "card_create_charge": cardCreateCharge.toJson(),
    "card_reload_charge": cardReloadCharge.toJson(),
    "totalAddMoney": totalAddMoney,
    "totalTransactions": totalTransactions,
    "active_cards": activeCards,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
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
    id: json["id"],
    slug: json["slug"],
    title: json["title"],
    fixedCharge: json["fixed_charge"],
    percentCharge: json["percent_charge"],
    minLimit: json["min_limit"],
    maxLimit: json["max_limit"],
    dailyLimit: json["daily_limit"],
    monthlyLimit: json["monthly_limit"],
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

class ModuleAccess {
  bool addMoney;
  bool transferMoney;
  bool withdrawMoney;
  bool virtualCard;
  bool giftCards;

  ModuleAccess({
    required this.addMoney,
    required this.transferMoney,
    required this.withdrawMoney,
    required this.virtualCard,
    required this.giftCards,
  });

  factory ModuleAccess.fromJson(Map<String, dynamic> json) => ModuleAccess(
    addMoney: json["add_money"],
    transferMoney: json["transfer_money"],
    withdrawMoney: json["withdraw_money"],
    virtualCard: json["virtual_card"],
    giftCards: json["gift_cards"],
  );

  Map<String, dynamic> toJson() => {
    "add_money": addMoney,
    "transfer_money": transferMoney,
    "withdraw_money": withdrawMoney,
    "virtual_card": virtualCard,
    "gift_cards": giftCards,
  };
}

class PusherCredentials {
  String instanceId;
  String secretKey;

  PusherCredentials({required this.instanceId, required this.secretKey});

  factory PusherCredentials.fromJson(Map<String, dynamic> json) =>
      PusherCredentials(
        instanceId: json["instanceId"],
        secretKey: json["secretKey"],
      );

  Map<String, dynamic> toJson() => {
    "instanceId": instanceId,
    "secretKey": secretKey,
  };
}

class Transaction {
  int id;
  String type;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String status;
  String remark;
  DateTime dateTime;

  Transaction({
    required this.id,
    required this.type,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.status,
    required this.remark,
    required this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    type: json["type"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    status: json["status"],
    remark: json["remark"],
    dateTime: DateTime.parse(json["date_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "trx": trx,
    "transaction_type": transactionType,
    "request_amount": requestAmount,
    "payable": payable,
    "status": status,
    "remark": remark,
    "date_time": dateTime.toIso8601String(),
  };
}

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String? mobileCode;
  String? mobile;
  String fullMobile;
  dynamic refferalUserId;
  String image;
  int status;
  // Address address;
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
  SudoCustomer? sudoCustomer;
  SudoAccount? sudoAccount;
  StrowalletCustomer? strowalletCustomer;
  dynamic stripeCardHolders;
  dynamic stripeConnectedAccount;
  int twoFactorStatus;
  String twoFactorSecret;
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
    this.mobile,
    required this.fullMobile,
    required this.refferalUserId,
    required this.image,
    required this.status,
    // required this.address,
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
    this.sudoCustomer,
    this.sudoAccount,
    this.strowalletCustomer,
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
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    email: json["email"],
    mobileCode: json["mobile_code"] ?? '',
    mobile: json["mobile"] ?? '',
    fullMobile: json["full_mobile"] ?? '',
    refferalUserId: json["refferal_user_id"] ?? '',
    image: json["image"] ?? '',
    status: json["status"],
    // address: Address.fromJson(json["address"]),
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
    sudoCustomer: json["sudo_customer"] != null
        ? SudoCustomer.fromJson(json["sudo_customer"])
        : null,

    sudoAccount: json["sudo_account"] != null
        ? SudoAccount.fromJson(json["sudo_account"])
        : null,

    strowalletCustomer: json["strowallet_customer"] != null
        ? StrowalletCustomer.fromJson(json["strowallet_customer"])
        : null,
    stripeCardHolders: json["stripe_card_holders"],
    stripeConnectedAccount: json["stripe_connected_account"],
    twoFactorStatus: json["two_factor_status"],
    twoFactorSecret: json["two_factor_secret"] ?? '',
    fullname: json["fullname"],
    userImage: json["userImage"],
    stringStatus: Status.fromJson(json["stringStatus"]),
    emailStatus: Status.fromJson(json["emailStatus"]),
    lastLogin: json["lastLogin"],
    kycStringStatus: Status.fromJson(json["kycStringStatus"]),
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
    // "address": address.toJson(),
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
    "sudo_customer": sudoCustomer?.toJson(),
    "sudo_account": sudoAccount?.toJson(),
    "strowallet_customer": strowalletCustomer?.toJson(),
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
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zip: json["zip"],
    address: json["address"],
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

  Status({required this.statusClass, required this.value});

  factory Status.fromJson(Map<String, dynamic> json) =>
      Status(statusClass: json["class"], value: json["value"]);

  Map<String, dynamic> toJson() => {"class": statusClass, "value": value};
}

class StrowalletCustomer {
  String customerEmail;
  String firstName;
  String lastName;
  String phoneNumber;
  String city;
  String state;
  String country;
  String line1;
  String zipCode;
  String houseNumber;
  String idNumber;
  String idType;
  String idImage;
  String userPhoto;
  String customerId;
  // DateTime dateOfBirth;
  String status;

  StrowalletCustomer({
    required this.customerEmail,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.city,
    required this.state,
    required this.country,
    required this.line1,
    required this.zipCode,
    required this.houseNumber,
    required this.idNumber,
    required this.idType,
    required this.idImage,
    required this.userPhoto,
    required this.customerId,
    // required this.dateOfBirth,
    required this.status,
  });

  factory StrowalletCustomer.fromJson(Map<String, dynamic> json) =>
      StrowalletCustomer(
        customerEmail: json["customerEmail"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        line1: json["line1"],
        zipCode: json["zipCode"],
        houseNumber: json["houseNumber"],
        idNumber: json["idNumber"],
        idType: json["idType"],
        idImage: json["idImage"],
        userPhoto: json["userPhoto"],
        customerId: json["customerId"],
        // dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
    "customerEmail": customerEmail,
    "firstName": firstName,
    "lastName": lastName,
    "phoneNumber": phoneNumber,
    "city": city,
    "state": state,
    "country": country,
    "line1": line1,
    "zipCode": zipCode,
    "houseNumber": houseNumber,
    "idNumber": idNumber,
    "idType": idType,
    "idImage": idImage,
    "userPhoto": userPhoto,
    "customerId": customerId,
    // "dateOfBirth":
    //     "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "status": status,
  };
}

class SudoAccount {
  String id;
  String business;
  String type;
  String currency;
  String accountName;
  String accountType;
  double currentBalance;
  double availableBalance;
  String provider;
  String providerReference;
  String referenceCode;
  bool isDefault;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<dynamic> charges;

  SudoAccount({
    required this.id,
    required this.business,
    required this.type,
    required this.currency,
    required this.accountName,
    required this.accountType,
    required this.currentBalance,
    required this.availableBalance,
    required this.provider,
    required this.providerReference,
    required this.referenceCode,
    required this.isDefault,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.charges,
  });

  factory SudoAccount.fromJson(Map<String, dynamic> json) => SudoAccount(
    id: json["_id"] ?? '',
    business: json["business"],
    type: json["type"],
    currency: json["currency"],
    accountName: json["accountName"],
    accountType: json["accountType"],
    currentBalance: json["currentBalance"]?.toDouble(),
    availableBalance: json["availableBalance"]?.toDouble(),
    provider: json["provider"],
    providerReference: json["providerReference"],
    referenceCode: json["referenceCode"],
    isDefault: json["isDefault"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    charges: List<dynamic>.from(json["charges"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "business": business,
    "type": type,
    "currency": currency,
    "accountName": accountName,
    "accountType": accountType,
    "currentBalance": currentBalance,
    "availableBalance": availableBalance,
    "provider": provider,
    "providerReference": providerReference,
    "referenceCode": referenceCode,
    "isDefault": isDefault,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "charges": List<dynamic>.from(charges.map((x) => x)),
  };
}

class SudoCustomer {
  String business;
  String type;
  String name;
  String phoneNumber;
  String emailAddress;
  String status;
  Individual individual;
  BillingAddress billingAddress;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  int v;

  SudoCustomer({
    required this.business,
    required this.type,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.status,
    required this.individual,
    required this.billingAddress,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.v,
  });

  factory SudoCustomer.fromJson(Map<String, dynamic> json) => SudoCustomer(
    business: json["business"],
    type: json["type"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    emailAddress: json["emailAddress"],
    status: json["status"],
    individual: Individual.fromJson(json["individual"]),
    billingAddress: BillingAddress.fromJson(json["billingAddress"]),
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    id: json["_id"] ?? '',
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "business": business,
    "type": type,
    "name": name,
    "phoneNumber": phoneNumber,
    "emailAddress": emailAddress,
    "status": status,
    "individual": individual.toJson(),
    "billingAddress": billingAddress.toJson(),
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "_id": id,
    "__v": v,
  };
}

class BillingAddress {
  String line1;
  String line2;
  String city;
  String state;
  String country;
  String postalCode;
  String id;

  BillingAddress({
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.id,
  });

  factory BillingAddress.fromJson(Map<String, dynamic> json) => BillingAddress(
    line1: json["line1"],
    line2: json["line2"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postalCode"],
    id: json["_id"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "line1": line1,
    "line2": line2,
    "city": city,
    "state": state,
    "country": country,
    "postalCode": postalCode,
    "_id": id,
  };
}

class Individual {
  String firstName;
  String lastName;
  DateTime dob;
  Identity identity;
  String id;

  Individual({
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.identity,
    required this.id,
  });

  factory Individual.fromJson(Map<String, dynamic> json) => Individual(
    firstName: json["firstName"],
    lastName: json["lastName"],
    dob: DateTime.parse(json["dob"]),
    identity: Identity.fromJson(json["identity"]),
    id: json["_id"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob.toIso8601String(),
    "identity": identity.toJson(),
    "_id": id,
  };
}

class Identity {
  String type;
  String number;
  String id;

  Identity({required this.type, required this.number, required this.id});

  factory Identity.fromJson(Map<String, dynamic> json) =>
      Identity(type: json["type"], number: json["number"], id: json["_id"] ?? '');

  Map<String, dynamic> toJson() => {"type": type, "number": number, "_id": id};
}

class UserWallet {
  double balance;
  int status;
  Currency currency;

  UserWallet({
    required this.balance,
    required this.status,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    balance: json["balance"]?.toDouble(),
    status: json["status"],
    currency: Currency.fromJson(json["currency"]),
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
