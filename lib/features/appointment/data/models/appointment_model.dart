// To parse this JSON data, do
//
//     final appointmentModel = appointmentModelFromJson(jsonString);

import 'dart:convert';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

List<AppointmentModel> appointmentModelListFromJson(String str) =>
    List<AppointmentModel>.from(
        json.decode(str).map((x) => AppointmentModel.fromJson(x)));

String appointmentModelListToJson(List<AppointmentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

AppointmentModel appointmentModelFromJson(String str) =>
    AppointmentModel.fromJson(json.decode(str));

String appointmentModelToJson(AppointmentModel data) =>
    json.encode(data.toJson());

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.date,
    required super.endTime,
    super.id,
    required super.startTime,
    required super.trainerId,
    required super.userId,
    super.remark,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      AppointmentModel(
        date: DateTime.parse(json["date"]),
        endTime: json["endTime"],
        id: json["id"],
        startTime: json["startTime"],
        trainerId: json["trainerId"],
        userId: json["userId"],
        remark: json["remark"],
      );

  factory AppointmentModel.fromEntity(Appointment e) => AppointmentModel(
        date: e.date,
        endTime: e.endTime,
        id: e.id,
        startTime: e.startTime,
        trainerId: e.trainerId,
        userId: e.userId,
        remark: e.remark,
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "endTime": endTime,
        "id": id,
        "startTime": startTime,
        "trainerId": trainerId,
        "userId": userId,
        "remark": remark,
      };
}
