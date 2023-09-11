// To parse this JSON data, do
//
//     final currencyResponse = currencyResponseFromJson(jsonString);

import 'dart:convert';

CurrencyResponse currencyResponseFromJson(String str) => CurrencyResponse.fromJson(json.decode(str));

String currencyResponseToJson(CurrencyResponse data) => json.encode(data.toJson());

class CurrencyResponse {
  CurrencyResponse({
     this.data,
     this.success,
     this.status,
  });

  List<CurrencyInfo>? data;
  bool? success;
  int? status;

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) => CurrencyResponse(
    data: List<CurrencyInfo>.from(json["data"].map((x) => CurrencyInfo.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class CurrencyInfo {
  CurrencyInfo({
     this.id,
     this.name,
     this.code,
     this.symbol,
     this.exchangeRate,
     this.isDefault,
  });

  int? id;
  String? name;
  String? code;
  String? symbol;
  String? exchangeRate;
  bool? isDefault;

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) => CurrencyInfo(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    symbol: json["symbol"],
    exchangeRate: json["exchange_rate"].toString()??null,
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "symbol": symbol,
    "exchange_rate": exchangeRate,
    "is_default": isDefault,
  };
}
