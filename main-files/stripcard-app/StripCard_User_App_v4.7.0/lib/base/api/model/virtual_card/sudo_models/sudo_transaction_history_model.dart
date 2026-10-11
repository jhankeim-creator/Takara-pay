
class SudoCardTransactionsModel {
  Message message;
  Data data;

  SudoCardTransactionsModel({
    required this.message,
    required this.data,
  });

  factory SudoCardTransactionsModel.fromJson(Map<String, dynamic> json) =>
      SudoCardTransactionsModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  CardTransactions cardTransactions;

  Data({
    required this.cardTransactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cardTransactions: CardTransactions.fromJson(json["cardTransactions"]),
      );

  Map<String, dynamic> toJson() => {
        "cardTransactions": cardTransactions.toJson(),
      };
}

class CardTransactions {
  int statusCode;
  String message;
  List<dynamic> data;
  Pagination pagination;

  CardTransactions({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CardTransactions.fromJson(Map<String, dynamic> json) =>
      CardTransactions(
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
        "pagination": pagination.toJson(),
      };
}

class Pagination {
  int total;
  int pages;
  int page;
  int limit;

  Pagination({
    required this.total,
    required this.pages,
    required this.page,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        pages: json["pages"],
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "pages": pages,
        "page": page,
        "limit": limit,
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
