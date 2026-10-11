// To parse this JSON data, do
//
//     final cardTransactionModelCardyfie = cardTransactionModelCardyfieFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CardTransactionModelCardyfie cardTransactionModelCardyfieFromJson(String str) =>
    CardTransactionModelCardyfie.fromJson(json.decode(str));

String cardTransactionModelCardyfieToJson(CardTransactionModelCardyfie data) =>
    json.encode(data.toJson());

class CardTransactionModelCardyfie {
  Message message;
  Data data;

  CardTransactionModelCardyfie({required this.message, required this.data});

  factory CardTransactionModelCardyfie.fromJson(Map<String, dynamic> json) =>
      CardTransactionModelCardyfie(
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
  List<CardTransaction> cardTransactions;

  Data({required this.baseCurr, required this.cardTransactions});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    baseCurr: json["base_curr"],
    cardTransactions: List<CardTransaction>.from(
      json["card_transactions"].map((x) => CardTransaction.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "base_curr": baseCurr,
    "card_transactions": List<dynamic>.from(
      cardTransactions.map((x) => x.toJson()),
    ),
  };
}

class CardTransaction {
  String ulid;
  String trxType;
  String trxId;
  String cardCurrency;
  String enterAmount;
  DateTime createdAt;
  String amountType;
  String status;

  CardTransaction({
    required this.ulid,
    required this.trxType,
    required this.trxId,
    required this.cardCurrency,
    required this.enterAmount,
    required this.createdAt,
    required this.amountType,
    required this.status,
  });

  factory CardTransaction.fromJson(Map<String, dynamic> json) =>
      CardTransaction(
        ulid: json["ulid"],
        trxType: json["trx_type"],
        trxId: json["trx_id"],
        cardCurrency: json["card_currency"],
        enterAmount: json["enter_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        amountType: json["amount_type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "ulid": ulid,
    "trx_type": trxType,
    "trx_id": trxId,
    "card_currency": cardCurrency,
    "enter_amount": enterAmount,
    "created_at": createdAt.toIso8601String(),
    "amount_type": amountType,
    "status": status,
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
