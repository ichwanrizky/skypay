// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String initials;
  String name;
  String phoneNumber;

  UserModel({
    required this.id,
    required this.initials,
    required this.name,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        initials: json["initials"],
        name: json["name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "initials": initials,
        "name": name,
        "phone_number": phoneNumber,
      };
}
