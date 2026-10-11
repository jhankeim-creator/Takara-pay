import 'dart:convert';

/// Response model for `GET /user/strowallet-card/get/card-holder`
/// (the "Manage Card Holder" flow). `card_holder` is null when the user has
/// not created one yet, so every field is parsed defensively.
StrowalletCardHolderModel strowalletCardHolderModelFromJson(String str) =>
    StrowalletCardHolderModel.fromJson(json.decode(str));

class StrowalletCardHolderModel {
  StrowalletCardHolderModel({required this.data});

  final CardHolderData data;

  factory StrowalletCardHolderModel.fromJson(Map<String, dynamic> json) =>
      StrowalletCardHolderModel(
        data: CardHolderData.fromJson(
          (json["data"] as Map<String, dynamic>?) ?? const {},
        ),
      );
}

class CardHolderData {
  CardHolderData({required this.cardHolder});

  /// Null when no card-holder exists yet.
  final CardHolder? cardHolder;

  bool get exists => cardHolder != null;

  factory CardHolderData.fromJson(Map<String, dynamic> json) {
    final raw = json["card_holder"];
    return CardHolderData(
      cardHolder: raw is Map<String, dynamic> ? CardHolder.fromJson(raw) : null,
    );
  }
}

class CardHolder {
  CardHolder({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.idType,
    required this.idNumber,
    required this.email,
    required this.line1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phoneCode,
    required this.phone,
    required this.idImage,
    required this.faceImage,
    this.accountPurpose,
    this.employmentStatus,
    this.occupation,
  });

  final int id;
  final String name;
  final String firstName;
  final String lastName;
  final String dob;
  final String idType;
  final String idNumber;
  final String email;
  final String line1;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phoneCode;
  final String phone;
  final String idImage;
  final String faceImage;
  // Nullable: older backend responses predate these fields.
  final String? accountPurpose;
  final String? employmentStatus;
  final String? occupation;

  static String _s(dynamic v) => v == null ? '' : v.toString();

  factory CardHolder.fromJson(Map<String, dynamic> json) => CardHolder(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(_s(json["id"])) ?? 0,
        name: _s(json["name"]),
        firstName: _s(json["first_name"]),
        lastName: _s(json["last_name"]),
        dob: _s(json["dob"]),
        idType: _s(json["id_type"]),
        idNumber: _s(json["id_number"]),
        email: _s(json["email"]),
        line1: _s(json["line1"]),
        city: _s(json["city"]),
        state: _s(json["state"]),
        postalCode: _s(json["postal_code"]),
        country: _s(json["country"]),
        phoneCode: _s(json["phone_code"]),
        phone: _s(json["phone"]),
        idImage: _s(json["id_image"]),
        faceImage: _s(json["face_image"]),
        accountPurpose: json["account_purpose"] as String?,
        employmentStatus: json["employment_status"] as String?,
        occupation: json["occupation"] as String?,
      );
}
