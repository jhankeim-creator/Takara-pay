import 'package:meta/meta.dart';
import 'dart:convert';

CreateCardInfoModelCardyfie createCardInfoModelCardyfieFromJson(String str) =>
    CreateCardInfoModelCardyfie.fromJson(json.decode(str));

String createCardInfoModelCardyfieToJson(CreateCardInfoModelCardyfie data) =>
    json.encode(data.toJson());

class CreateCardInfoModelCardyfie {
  Message message;
  Data data;

  CreateCardInfoModelCardyfie({required this.message, required this.data});

  factory CreateCardInfoModelCardyfie.fromJson(Map<String, dynamic> json) =>
      CreateCardInfoModelCardyfie(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  User user;
  bool customerExistStatus;
  String customerPendingText;
  CustomerExist customerExist;
  bool cardCreateStatus;

  Data({
    required this.user,
    required this.customerExistStatus,
    required this.customerPendingText,
    required this.customerExist,
    required this.cardCreateStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    customerExistStatus: json["customer_exist_status"],
    customerPendingText: json["customer_pending_text"],
    customerExist: CustomerExist.fromJson(json["customer_exist"]),
    cardCreateStatus: json["card_create_status"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "customer_exist_status": customerExistStatus,
    "customer_pending_text": customerPendingText,
    "customer_exist": customerExist.toJson(),
    "card_create_status": cardCreateStatus,
  };
}

class CustomerExist {
  int id;
  String userType;
  int userId;
  String ulid;
  String referenceId;
  String firstName;
  String lastName;
  String email;
  // DateTime dateOfBirth;
  String idType;
  String idNumber;
  // String idFrontImage;
  String customerExistIdBackImage;
  String customerExistUserImage;
  String houseNumber;
  String addressLine1;
  String city;
  String state;
  String zipCode;
  String country;
  String status;
  dynamic meta;
  DateTime createdAt;
  DateTime updatedAt;
  String idFontImage;
  String idBackImage;
  String userImage;

  CustomerExist({
    required this.id,
    required this.userType,
    required this.userId,
    required this.ulid,
    required this.referenceId,
    required this.firstName,
    required this.lastName,
    required this.email,
    // required this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    // required this.idFrontImage,
    required this.customerExistIdBackImage,
    required this.customerExistUserImage,
    required this.houseNumber,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.status,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.idFontImage,
    required this.idBackImage,
    required this.userImage,
  });

  factory CustomerExist.fromJson(Map<String, dynamic> json) => CustomerExist(
    id: json["id"],
    userType: json["user_type"],
    userId: json["user_id"],
    ulid: json["ulid"],
    referenceId: json["reference_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    // dateOfBirth: DateTime.parse(json["date_of_birth"]),
    idType: json["id_type"],
    idNumber: json["id_number"],
    // idFrontImage: json["id_front_image"],
    customerExistIdBackImage: json["id_back_image"],
    customerExistUserImage: json["user_image"],
    houseNumber: json["house_number"],
    addressLine1: json["address_line_1"],
    city: json["city"],
    state: json["state"],
    zipCode: json["zip_code"],
    country: json["country"],
    status: json["status"],
    meta: json["meta"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    idFontImage: json["idFontImage"],
    idBackImage: json["idBackImage"],
    userImage: json["userImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_type": userType,
    "user_id": userId,
    "ulid": ulid,
    "reference_id": referenceId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    // "date_of_birth":
    //     "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "id_type": idType,
    "id_number": idNumber,
    // "id_front_image": idFrontImage,
    "id_back_image": customerExistIdBackImage,
    "user_image": customerExistUserImage,
    "house_number": houseNumber,
    "address_line_1": addressLine1,
    "city": city,
    "state": state,
    "zip_code": zipCode,
    "country": country,
    "status": status,
    "meta": meta,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "idFontImage": idFontImage,
    "idBackImage": idBackImage,
    "userImage": userImage,
  };
}

class User {
  int id;
  String firstname;
  String lastname;
  String username;
  String email;
  String mobileCode;
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
  CustomerExist cardyfieCardCustomer;

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
    required this.cardyfieCardCustomer,
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
    address: Address.fromJson(json["address"]),
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
    cardyfieCardCustomer: CustomerExist.fromJson(
      json["cardyfie_card_customer"],
    ),
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
    "cardyfie_card_customer": cardyfieCardCustomer.toJson(),
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

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x)),
  };
}
