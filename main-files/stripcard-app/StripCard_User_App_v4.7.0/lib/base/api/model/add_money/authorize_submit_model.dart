

import 'package:meta/meta.dart';
import 'dart:convert';

AddMoneyAuthorizeModel addMoneyAuthorizeModelFromJson(String str) => AddMoneyAuthorizeModel.fromJson(json.decode(str));

String addMoneyAuthorizeModelToJson(AddMoneyAuthorizeModel data) => json.encode(data.toJson());

class AddMoneyAuthorizeModel {
    Message message;
    Data data;

    AddMoneyAuthorizeModel({
        required this.message,
        required this.data,
    });

    factory AddMoneyAuthorizeModel.fromJson(Map<String, dynamic> json) => AddMoneyAuthorizeModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
    };
}

class Data {
    String gatewayType;
    String gatewayCurrencyName;
    String alias;
    String identify;
    String tempToken;

    Data({
        required this.gatewayType,
        required this.gatewayCurrencyName,
        required this.alias,
        required this.identify,
        required this.tempToken,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        gatewayType: json["gateway_type"],
        gatewayCurrencyName: json["gateway_currency_name"],
        alias: json["alias"],
        identify: json["identify"],
        tempToken: json["tempToken"],
    );

    Map<String, dynamic> toJson() => {
        "gateway_type": gatewayType,
        "gateway_currency_name": gatewayCurrencyName,
        "alias": alias,
        "identify": identify,
        "tempToken": tempToken,
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
