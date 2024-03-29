// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'dart:convert';


import 'dart:convert';

List<AppointmentModel> appointmentModelListFromJson(String str) => List<AppointmentModel>.from(json.decode(str).map((x) => AppointmentModel.fromJson(x)));

String appointmentModelListToJson(List<AppointmentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

AppointmentModel appointmentModelFromJson(String str) => AppointmentModel.fromJson(json.decode(str));

String appointmentModelToJson(AppointmentModel data) => json.encode(data.toJson());

class AppointmentModel {
  DateTime date;
  String endTime;
  int? id;
  String startTime;
  int trainerId;
  int userId;

  AppointmentModel({
    required this.date,
    required this.endTime,
     this.id,
    required this.startTime,
    required this.trainerId,
    required this.userId,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) => AppointmentModel(
    date: DateTime.parse(json["date"]),
    endTime: json["endTime"],
    id: json["id"],
    startTime: json["startTime"],
    trainerId: json["trainerId"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "endTime": endTime,
    "id": id,
    "startTime": startTime,
    "trainerId": trainerId,
    "userId": userId,
  };
}
