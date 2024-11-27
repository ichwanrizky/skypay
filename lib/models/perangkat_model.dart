// To parse this JSON data, do
//
//     final perangkatModel = perangkatModelFromJson(jsonString);

import 'dart:convert';

PerangkatModel perangkatModelFromJson(String str) =>
    PerangkatModel.fromJson(json.decode(str));

String perangkatModelToJson(PerangkatModel data) => json.encode(data.toJson());

class PerangkatModel {
  int totalAssociations;
  int totalLan;
  List<AssociatedDevice> associatedDevices;

  PerangkatModel({
    required this.totalAssociations,
    required this.totalLan,
    required this.associatedDevices,
  });

  factory PerangkatModel.fromJson(Map<String, dynamic> json) => PerangkatModel(
        totalAssociations: json["total_associations"],
        totalLan: json["total_lan"],
        associatedDevices: List<AssociatedDevice>.from(
            json["associated_devices"]
                .map((x) => AssociatedDevice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_associations": totalAssociations,
        "total_lan": totalLan,
        "associated_devices":
            List<dynamic>.from(associatedDevices.map((x) => x.toJson())),
      };
}

class AssociatedDevice {
  String deviceName;
  int ssidId;
  String macAddress;
  String ipAddress;
  String signalStrength;
  String signalStrengthColor;
  String rxRate;
  String txRate;

  AssociatedDevice({
    required this.deviceName,
    required this.ssidId,
    required this.macAddress,
    required this.ipAddress,
    required this.signalStrength,
    required this.signalStrengthColor,
    required this.rxRate,
    required this.txRate,
  });

  factory AssociatedDevice.fromJson(Map<String, dynamic> json) =>
      AssociatedDevice(
        deviceName: json["deviceName"],
        ssidId: json["ssidId"],
        macAddress: json["macAddress"],
        ipAddress: json["ipAddress"],
        signalStrength: json["signalStrength"],
        signalStrengthColor: json["signalStrengthColor"],
        rxRate: json["rxRate"],
        txRate: json["txRate"],
      );

  Map<String, dynamic> toJson() => {
        "deviceName": deviceName,
        "ssidId": ssidId,
        "macAddress": macAddress,
        "ipAddress": ipAddress,
        "signalStrength": signalStrength,
        "signalStrengthColor": signalStrengthColor,
        "rxRate": rxRate,
        "txRate": txRate,
      };
}
