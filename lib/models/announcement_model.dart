// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';

AnnouncementModel announcementModelFromJson(String str) =>
    AnnouncementModel.fromJson(json.decode(str));

String announcementModelToJson(AnnouncementModel data) =>
    json.encode(data.toJson());

class AnnouncementModel {
  String? type;
  String? title;
  String? content;
  String? lastUpdatedAt;

  AnnouncementModel({
    this.type,
    this.title,
    this.content,
    this.lastUpdatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        type: json["type"],
        title: json["title"],
        content: json["content"],
        lastUpdatedAt: json["last_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "content": content,
        "last_updated_at": lastUpdatedAt,
      };
}
