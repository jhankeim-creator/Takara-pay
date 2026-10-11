class SudoMyCardModel {
  Message message;
  Data data;

  SudoMyCardModel({
    required this.message,
    required this.data,
  });

  factory SudoMyCardModel.fromJson(Map<String, dynamic> json) => SudoMyCardModel(
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
  int baseCurrRate;
  GetRemainingFields getRemainingFields;
  List<SupportedCurrency> supportedCurrency;
  bool cardCreateAction;
  bool cardExtraFieldsStatus;
  List<CardExtraField> cardExtraFields;
  CardBasicInfo cardBasicInfo;
  List<MyCard> myCard;
  List<UserWallet> userWallet;
  CardCharge cardCharge;
  List<Transaction> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.getRemainingFields,
    required this.supportedCurrency,
    required this.cardCreateAction,
    required this.cardExtraFieldsStatus,
    required this.cardExtraFields,
    required this.cardBasicInfo,
    required this.myCard,
    required this.userWallet,
    required this.cardCharge,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    baseCurr: json["base_curr"],
    baseCurrRate: json["base_curr_rate"],
    getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),
    supportedCurrency: List<SupportedCurrency>.from(json["supported_currency"].map((x) => SupportedCurrency.fromJson(x))),
    cardCreateAction: json["card_create_action"] ?? false,
    cardExtraFieldsStatus: json["card_extra_fields_status"] ?? false,
    cardExtraFields: List<CardExtraField>.from(json["card_extra_fields"].map((x) => CardExtraField.fromJson(x))),
    cardBasicInfo: CardBasicInfo.fromJson(json["card_basic_info"]),
    myCard: List<MyCard>.from(json["myCard"].map((x) => MyCard.fromJson(x))),
    userWallet: List<UserWallet>.from(json["userWallet"].map((x) => UserWallet.fromJson(x))),
    cardCharge: CardCharge.fromJson(json["cardCharge"]),
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "base_curr": baseCurr,
    "base_curr_rate": baseCurrRate,
    "get_remaining_fields": getRemainingFields.toJson(),
    "supported_currency": List<dynamic>.from(supportedCurrency.map((x) => x.toJson())),
    "card_create_action": cardCreateAction,
    "card_extra_fields_status": cardExtraFieldsStatus,
    "card_extra_fields": List<dynamic>.from(cardExtraFields.map((x) => x.toJson())),
    "card_basic_info": cardBasicInfo.toJson(),
    "myCard": List<dynamic>.from(myCard.map((x) => x.toJson())),
    "userWallet": List<dynamic>.from(userWallet.map((x) => x.toJson())),
    "cardCharge": cardCharge.toJson(),
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
  };
}

class CardBasicInfo {
  int cardCreateLimit;
  String cardBackDetails;
  String cardBg;
  String siteTitle;
  String siteLogo;
  String siteFav;

  CardBasicInfo({
    required this.cardCreateLimit,
    required this.cardBackDetails,
    required this.cardBg,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
  });

  factory CardBasicInfo.fromJson(Map<String, dynamic> json) => CardBasicInfo(
    cardCreateLimit: json["card_create_limit"] ?? 0,
    cardBackDetails: json["card_back_details"],
    cardBg: json["card_bg"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    siteFav: json["site_fav"],
  );

  Map<String, dynamic> toJson() => {
    "card_create_limit": cardCreateLimit,
    "card_back_details": cardBackDetails,
    "card_bg": cardBg,
    "site_title": siteTitle,
    "site_logo": siteLogo,
    "site_fav": siteFav,
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

class CardExtraField {
  int id;
  String type;
  String fieldName;
  String labelName;
  String placeHolder;
  String value;
  List<Option> options;

  CardExtraField({
    required this.id,
    required this.type,
    required this.fieldName,
    required this.labelName,
    required this.placeHolder,
    required this.value,
    required this.options,
  });

  factory CardExtraField.fromJson(Map<String, dynamic> json) => CardExtraField(
    id: json["id"],
    type: json["type"],
    fieldName: json["field_name"],
    labelName: json["label_name"],
    placeHolder: json["place_holder"],
    value: json["value"],
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "field_name": fieldName,
    "label_name": labelName,
    "place_holder": placeHolder,
    "value": value,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  int id;
  String name;
  String value;

  Option({
    required this.id,
    required this.name,
    required this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "value": value,
  };
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({
    required this.transactionType,
    required this.attribute,
  });

  factory GetRemainingFields.fromJson(Map<String, dynamic> json) => GetRemainingFields(
    transactionType: json["transaction_type"],
    attribute: json["attribute"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_type": transactionType,
    "attribute": attribute,
  };
}

class MyCard {
  int id;
  String cardId;
  int amount;
  String currency;
  String cardHolder;
  String brand;
  String type;
  String cardPan;
  String expiryMonth;
  String expiryYear;
  String cvv;
  String cardBackDetails;
  String siteTitle;
  String siteLogo;
  String siteFav;
  bool status;
  bool isDefault;
  MyCardStatusInfo statusInfo;
  String cardApiMode;

  MyCard({
    required this.id,
    required this.cardId,
    required this.amount,
    required this.currency,
    required this.cardHolder,
    required this.brand,
    required this.type,
    required this.cardPan,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardBackDetails,
    required this.siteTitle,
    required this.siteLogo,
    required this.siteFav,
    required this.status,
    required this.isDefault,
    required this.statusInfo,
    required this.cardApiMode,
  });

  factory MyCard.fromJson(Map<String, dynamic> json) => MyCard(
    id: json["id"],
    cardId: json["card_id"],
    amount: json["amount"],
    currency: json["currency"],
    cardHolder: json["card_holder"],
    brand: json["brand"],
    type: json["type"],
    cardPan: json["card_pan"],
    expiryMonth: json["expiry_month"],
    expiryYear: json["expiry_year"],
    cvv: json["cvv"],
    cardBackDetails: json["card_back_details"],
    siteTitle: json["site_title"],
    siteLogo: json["site_logo"],
    siteFav: json["site_fav"],
    status: json["status"],
    isDefault: json["is_default"] ?? false,
    statusInfo: MyCardStatusInfo.fromJson(json["status_info"]),
    cardApiMode: json["card_api_mode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "card_id": cardId,
    "amount": amount,
    "currency": currency,
    "card_holder": cardHolder,
    "brand": brand,
    "type": type,
    "card_pan": cardPan,
    "expiry_month": expiryMonth,
    "expiry_year": expiryYear,
    "cvv": cvv,
    "card_back_details": cardBackDetails,
    "site_title": siteTitle,
    "site_logo": siteLogo,
    "site_fav": siteFav,
    "status": status,
    "is_default": isDefault,
    "status_info": statusInfo.toJson(),
    "card_api_mode": cardApiMode,
  };
}

class MyCardStatusInfo {
  int block;
  int unblock;

  MyCardStatusInfo({
    required this.block,
    required this.unblock,
  });

  factory MyCardStatusInfo.fromJson(Map<String, dynamic> json) => MyCardStatusInfo(
    block: json["block"],
    unblock: json["unblock"],
  );

  Map<String, dynamic> toJson() => {
    "block": block,
    "unblock": unblock,
  };
}

class SupportedCurrency {
  int id;
  String name;
  String mobileCode;
  String currencyName;
  String currencyCode;
  String currencySymbol;
  dynamic rate;
  int status;

  SupportedCurrency({
    required this.id,
    required this.name,
    required this.mobileCode,
    required this.currencyName,
    required this.currencyCode,
    required this.currencySymbol,
    required this.rate,
    required this.status,
  });

  factory SupportedCurrency.fromJson(Map<String, dynamic> json) => SupportedCurrency(
    id: json["id"],
    name: json["name"],
    mobileCode: json["mobile_code"],
    currencyName: json["currency_name"],
    currencyCode: json["currency_code"],
    currencySymbol: json["currency_symbol"],
    rate: json["rate"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_code": mobileCode,
    "currency_name": currencyName,
    "currency_code": currencyCode,
    "currency_symbol": currencySymbol,
    "rate": rate,
    "status": status,
  };
}

class Transaction {
  int id;
  String trx;
  String transactionType;
  String requestAmount;
  String payable;
  String totalCharge;
  String cardAmount;
  String cardNumber;
  String currentBalance;
  String status;
  DateTime dateTime;
  TransactionStatusInfo statusInfo;

  Transaction({
    required this.id,
    required this.trx,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.totalCharge,
    required this.cardAmount,
    required this.cardNumber,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    trx: json["trx"],
    transactionType: json["transaction_type"],
    requestAmount: json["request_amount"],
    payable: json["payable"],
    totalCharge: json["total_charge"],
    cardAmount: json["card_amount"],
    cardNumber: json["card_number"],
    currentBalance: json["current_balance"],
    status: json["status"],
    dateTime: DateTime.parse(json["date_time"]),
    statusInfo: TransactionStatusInfo.fromJson(json["status_info"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trx": trx,
    "transaction_type": transactionType,
    "request_amount": requestAmount,
    "payable": payable,
    "total_charge": totalCharge,
    "card_amount": cardAmount,
    "card_number": cardNumber,
    "current_balance": currentBalance,
    "status": status,
    "date_time": dateTime.toIso8601String(),
    "status_info": statusInfo.toJson(),
  };
}

class TransactionStatusInfo {
  int success;
  int pending;
  int rejected;

  TransactionStatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory TransactionStatusInfo.fromJson(Map<String, dynamic> json) => TransactionStatusInfo(
    success: json["success"],
    pending: json["pending"],
    rejected: json["rejected"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "pending": pending,
    "rejected": rejected,
  };
}

class UserWallet {
  dynamic balance;
  int status;
  Currency currency;

  UserWallet({
    required this.balance,
    required this.status,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
    balance: json["balance"] ?? '',
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
