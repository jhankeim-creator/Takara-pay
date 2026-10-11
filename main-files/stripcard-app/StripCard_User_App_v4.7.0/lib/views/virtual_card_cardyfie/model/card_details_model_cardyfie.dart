// To parse this JSON data, do
//
//     final cardDetailsModelCardyfie = cardDetailsModelCardyfieFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CardDetailsModelCardyfie cardDetailsModelCardyfieFromJson(String str) => CardDetailsModelCardyfie.fromJson(json.decode(str));

String cardDetailsModelCardyfieToJson(CardDetailsModelCardyfie data) => json.encode(data.toJson());

class CardDetailsModelCardyfie {
    Message message;
    Data data;

    CardDetailsModelCardyfie({
        required this.message,
        required this.data,
    });

    factory CardDetailsModelCardyfie.fromJson(Map<String, dynamic> json) => CardDetailsModelCardyfie(
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
    MyCard myCard;

    Data({
        required this.baseCurr,
        required this.myCard,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        myCard: MyCard.fromJson(json["myCard"]),
    );

    Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "myCard": myCard.toJson(),
    };
}

class MyCard {
    int id;
    String referenceId;
    String ulid;
    String customerUlid;
    String cardName;
    String amount;
    String currency;
    String cardTier;
    String cardType;
    String cardExpTime;
    String maskedPan;
    String realPan;
    String cvv;
    String address;
    String status;
    String env;
    String isDefault;
    DateTime createdAt;
    DateTime updatedAt;

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
        required this.realPan,
        required this.cvv,
        required this.address,
        required this.status,
        required this.env,
        required this.isDefault,
        required this.createdAt,
        required this.updatedAt,
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
        realPan: json["real_pan"],
        cvv: json["cvv"],
        address: json["address"],
        status: json["status"],
        env: json["env"],
        isDefault: json["is_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "real_pan": realPan,
        "cvv": cvv,
        "address": address,
        "status": status,
        "env": env,
        "is_default": isDefault,
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
