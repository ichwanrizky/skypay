// To parse this JSON data, do
//
//     final ssidModel = ssidModelFromJson(jsonString);

import 'dart:convert';

List<SsidModel> ssidModelFromJson(String str) =>
    List<SsidModel>.from(json.decode(str).map((x) => SsidModel.fromJson(x)));

String ssidModelToJson(List<SsidModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SsidModel {
  int id;
  String ssid;

  SsidModel({
    required this.id,
    required this.ssid,
  });

  factory SsidModel.fromJson(Map<String, dynamic> json) => SsidModel(
        id: json["id"],
        ssid: json["ssid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ssid": ssid,
      };
}
