// To parse this JSON data, do
//
//     final editCustomerModelCardyfie = editCustomerModelCardyfieFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EditCustomerModelCardyfie editCustomerModelCardyfieFromJson(String str) =>
    EditCustomerModelCardyfie.fromJson(json.decode(str));

String editCustomerModelCardyfieToJson(EditCustomerModelCardyfie data) =>
    json.encode(data.toJson());

class EditCustomerModelCardyfie {
  Message message;
  Data data;

  EditCustomerModelCardyfie({required this.message, required this.data});

  factory EditCustomerModelCardyfie.fromJson(Map<String, dynamic> json) =>
      EditCustomerModelCardyfie(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "message": message.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  CardCustomer cardCustomer;

  Data({required this.cardCustomer});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(cardCustomer: CardCustomer.fromJson(json["card_customer"]));

  Map<String, dynamic> toJson() => {"card_customer": cardCustomer.toJson()};
}

class CardCustomer {
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
  String idFrontImage;
  String cardCustomerIdBackImage;
  String cardCustomerUserImage;
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

  CardCustomer({
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
    required this.idFrontImage,
    required this.cardCustomerIdBackImage,
    required this.cardCustomerUserImage,
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

  factory CardCustomer.fromJson(Map<String, dynamic> json) => CardCustomer(
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
    idFrontImage: json["id_front_image"],
    cardCustomerIdBackImage: json["id_back_image"],
    cardCustomerUserImage: json["user_image"],
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
    "id_front_image": idFrontImage,
    "id_back_image": cardCustomerIdBackImage,
    "user_image": cardCustomerUserImage,
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

class Message {
  List<String> success;

  Message({required this.success});

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(success: List<String>.from(json["success"].map((x) => x)));

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x)),
  };
}
