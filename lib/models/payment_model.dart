// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  String? pgCode;
  String? pgName;
  String? paymentCode;
  int? feeAmount;

  PaymentModel({this.pgCode, this.pgName, this.paymentCode, this.feeAmount});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        pgCode: json["pg_code"],
        pgName: json["pg_name"],
        paymentCode: json["payment_code"],
        feeAmount: json["fee_amount"],
      );

  Map<String, dynamic> toJson() => {
        "pg_code": pgCode,
        "pg_name": pgName,
        "payment_code": paymentCode,
        "fee_amount": feeAmount
      };
}
