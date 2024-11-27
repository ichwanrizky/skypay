// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  int? id;
  int? subscriptionId;
  String? invoiceNumber;
  List<Item>? items;
  int? price;
  int? isTaxed;
  String? invoiceDate;
  String? dueDate;
  dynamic notes;
  List<SubPayment>? subscriptionPayments;
  Subscription subscription;
  int? discountAmount;

  InvoiceModel(
      {this.id,
      this.subscriptionId,
      this.invoiceNumber,
      this.items,
      this.price,
      this.isTaxed,
      this.invoiceDate,
      this.dueDate,
      this.notes,
      this.subscriptionPayments,
      required this.subscription,
      this.discountAmount});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        subscriptionId: json["subscription_id"],
        invoiceNumber: json["invoice_number"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        price: json["price"],
        isTaxed: json["is_taxed"],
        invoiceDate: json["invoice_date"],
        dueDate: json["due_date"],
        notes: json["notes"],
        subscriptionPayments: json["subscription_payments"] == null
            ? []
            : List<SubPayment>.from(json["subscription_payments"]!
                .map((x) => SubPayment.fromJson(x))),
        subscription: Subscription.fromJson(json["subscription"]),
        discountAmount: json["discount_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription_id": subscriptionId,
        "invoice_number": invoiceNumber,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "price": price,
        "is_taxed": isTaxed,
        "invoice_date": invoiceDate,
        "due_date": dueDate,
        "notes": notes,
        "subscription_payments": subscriptionPayments == null
            ? []
            : List<dynamic>.from(subscriptionPayments!.map((x) => x.toJson())),
        "subscription": subscription.toJson(),
        "discount_amount": discountAmount
      };
}

class Item {
  String? name;
  int? price;
  int? totalPrice;

  Item({
    this.name,
    this.price,
    this.totalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
        price: json["price"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "total_price": totalPrice,
      };
}

class SubPayment {
  int? status;
  String? paymentMethod;
  int? paymentAmount;
  DateTime? paidAt;

  SubPayment({
    this.status,
    this.paymentMethod,
    this.paymentAmount,
    this.paidAt,
  });

  factory SubPayment.fromJson(Map<String, dynamic> json) => SubPayment(
        status: json["status"],
        paymentMethod: json["payment_name"],
        paymentAmount: json["payment_amount"],
        paidAt: DateTime.parse(json["paid_at"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "payment_name": paymentMethod,
        "payment_amount": paymentAmount,
        "paid_at": paidAt,
      };
}

class Subscription {
  String? serviceId;

  Subscription({
    this.serviceId,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        serviceId: json["service_id"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
      };
}
