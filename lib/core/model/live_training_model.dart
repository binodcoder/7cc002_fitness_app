// To parse this JSON data, do
//
//     final liveTrainingModel = liveTrainingModelFromJson(jsonString);

import 'dart:convert';

List<LiveTrainingModel> liveTrainingModelsFromJson(String str) =>
    List<LiveTrainingModel>.from(json.decode(str).map((x) => LiveTrainingModel.fromJson(x)));

String liveTrainingModelsToJson(List<LiveTrainingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

LiveTrainingModel liveTrainingModelFromJson(String str) => LiveTrainingModel.fromJson(json.decode(str));

String liveTrainingModelToJson(LiveTrainingModel data) => json.encode(data.toJson());

class LiveTrainingModel {
  int trainerId;
  String title;
  String description;
  DateTime trainingDate;
  String startTime;
  String endTime;

  LiveTrainingModel({
    required this.trainerId,
    required this.title,
    required this.description,
    required this.trainingDate,
    required this.startTime,
    required this.endTime,
  });

  factory LiveTrainingModel.fromJson(Map<String, dynamic> json) => LiveTrainingModel(
        trainerId: json["trainerId"],
        title: json["title"],
        description: json["description"],
        trainingDate: DateTime.parse(json["trainingDate"]),
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "trainerId": trainerId,
        "title": title,
        "description": description,
        "trainingDate":
            "${trainingDate.year.toString().padLeft(4, '0')}-${trainingDate.month.toString().padLeft(2, '0')}-${trainingDate.day.toString().padLeft(2, '0')}",
        "startTime": startTime,
        "endTime": endTime,
      };
}
