// To parse this JSON data, do
//
//     final instructionModel = instructionModelFromJson(jsonString);

import 'dart:convert';

List<InstructionModel> instructionModelFromJson(String str) =>
    List<InstructionModel>.from(
        json.decode(str).map((x) => InstructionModel.fromJson(x)));

String instructionModelToJson(List<InstructionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InstructionModel {
  String title;
  List<String> steps;

  InstructionModel({
    required this.title,
    required this.steps,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) =>
      InstructionModel(
        title: json["title"],
        steps: List<String>.from(json["steps"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "steps": List<dynamic>.from(steps.map((x) => x)),
      };
}
