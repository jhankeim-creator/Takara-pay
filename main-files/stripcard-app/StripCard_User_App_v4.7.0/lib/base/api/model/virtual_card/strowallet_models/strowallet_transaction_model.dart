
import 'dart:convert';

StrowalletCardTransactionModel strowalletCardTransactionModelFromJson(String str) => StrowalletCardTransactionModel.fromJson(json.decode(str));

String strowalletCardTransactionModelToJson(StrowalletCardTransactionModel data) => json.encode(data.toJson());

class StrowalletCardTransactionModel {
    Message message;
    Data data;

    StrowalletCardTransactionModel({
        required this.message,
        required this.data,
    });

    factory StrowalletCardTransactionModel.fromJson(Map<String, dynamic> json) => StrowalletCardTransactionModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
    };
}

class Data {
    List<dynamic> cardTransactions;

    Data({
        required this.cardTransactions,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cardTransactions: List<dynamic>.from(json["card_transactions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "card_transactions": List<dynamic>.from(cardTransactions.map((x) => x)),
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
