class LoginModel {
  Message message;
  Data data;

  LoginModel({required this.message, required this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    message: Message.fromJson(json["message"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  String token;
  User user;

  Data({required this.token, required this.user});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(token: json["token"], user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {"token": token, "user": user.toJson()};
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
  List<Wallet> wallets;

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
    required this.wallets,
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
    sudoCustomer: json["sudo_customer"],
    sudoAccount: json["sudo_account"],
    strowalletCustomer: json["strowallet_customer"],
    stripeCardHolders: json["stripe_card_holders"],
    stripeConnectedAccount: json["stripe_connected_account"],
    twoFactorStatus: json["two_factor_status"],
    twoFactorSecret: json["two_factor_secret"],
    fullname: json["fullname"],
    userImage: json["userImage"],
    stringStatus: Status.fromJson(json["stringStatus"]),
    emailStatus: Status.fromJson(json["emailStatus"]),
    lastLogin: json["lastLogin"],
    kycStringStatus: Status.fromJson(json["kycStringStatus"]),
    wallets: List<Wallet>.from(json["wallets"].map((x) => Wallet.fromJson(x))),
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
    "wallets": List<dynamic>.from(wallets.map((x) => x.toJson())),
  };
}

class Address {
  String country;
  String city;
  String zip;
  String state;
  String address;

  Address({
    required this.country,
    required this.city,
    required this.zip,
    required this.state,
    required this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    country: json["country"],
    city: json["city"],
    zip: json["zip"],
    state: json["state"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "country": country,
    "city": city,
    "zip": zip,
    "state": state,
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

class Wallet {
  int id;
  int userId;
  int currencyId;
  dynamic balance;
  int status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.currencyId,
    required this.balance,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    id: json["id"],
    userId: json["user_id"],
    currencyId: json["currency_id"],
    balance: json["balance"]?.toDouble ?? 0.0,
    status: json["status"],
    createdAt: json["created_at"] != null && json["created_at"] is String
        ? DateTime.parse(json["created_at"])
        : null,
    updatedAt: json["updated_at"] != null && json["updated_at"] is String
        ? DateTime.parse(json["updated_at"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "currency_id": currencyId,
    "balance": balance,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
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
