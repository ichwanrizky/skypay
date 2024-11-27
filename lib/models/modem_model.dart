// To parse this JSON data, do
//
//     final modemModel = modemModelFromJson(jsonString);

import 'dart:convert';

List<ModemModel> modemModelFromJson(String str) =>
    List<ModemModel>.from(json.decode(str).map((x) => ModemModel.fromJson(x)));

String modemModelToJson(List<ModemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModemModel {
  int id;
  String serviceId;
  String status;
  String? deviceId;

  ModemModel({
    required this.id,
    required this.serviceId,
    required this.status,
    this.deviceId,
  });

  factory ModemModel.fromJson(Map<String, dynamic> json) => ModemModel(
        id: json["id"],
        serviceId: json["service_id"],
        status: json["status"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "status": status,
        "device_id": deviceId,
      };
}
