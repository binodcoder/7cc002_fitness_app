// To parse this JSON data, do
//
//     final walkModel = walkModelFromJson(jsonString);

import 'dart:convert';
import 'package:fitness_app/features/walk/domain/entities/walk.dart' as entity;
import 'package:intl/intl.dart';

List<WalkModel> walkModelsFromJson(String str) => List<WalkModel>.from(json.decode(str).map((x) => WalkModel.fromJson(x)));

String walkModelsToJson(List<WalkModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

WalkModel walkModelFromJson(String str) => WalkModel.fromJson(json.decode(str));

String walkModelToJson(WalkModel data) => json.encode(data.toJson());

class WalkModel extends entity.Walk {
  const WalkModel({
    super.id,
    required super.proposerId,
    required super.routeData,
    required super.date,
    required super.startTime,
    required super.startLocation,
    List<ParticipantModel> participants = const [],
  }) : super(participants: participants);

  factory WalkModel.fromJson(Map<String, dynamic> json) => WalkModel(
        id: json["id"],
        proposerId: json["proposerId"],
        routeData: json["routeData"],
        date: DateTime.parse(json["date"]),
        startTime: json["startTime"],
        startLocation: json["startLocation"],
        participants: json["participants"] != null
            ? List<ParticipantModel>.from(json["participants"].map((x) => ParticipantModel.fromJson(x)))
            : const [],
      );

  factory WalkModel.fromEntity(entity.Walk e) => WalkModel(
        id: e.id,
        proposerId: e.proposerId,
        routeData: e.routeData,
        date: e.date,
        startTime: e.startTime,
        startLocation: e.startLocation,
        participants: e.participants.map((p) => p is ParticipantModel ? p : ParticipantModel.fromEntity(p)).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "proposerId": proposerId,
        "routeData": routeData,
        "date": DateFormat("yyyy-MM-dd").format(date),
        "startTime": startTime,
        "startLocation": startLocation,
        "participants": participants.map((x) => (x as ParticipantModel).toJson()).toList(),
      };
}

class ParticipantModel extends entity.Participant {
  const ParticipantModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.institutionEmail,
    required super.gender,
    required super.age,
    required super.role,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) => ParticipantModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        institutionEmail: json["institutionEmail"],
        gender: json["gender"],
        age: json["age"],
        role: json["role"],
      );

  factory ParticipantModel.fromEntity(entity.Participant e) => ParticipantModel(
        id: e.id,
        name: e.name,
        email: e.email,
        password: e.password,
        institutionEmail: e.institutionEmail,
        gender: e.gender,
        age: e.age,
        role: e.role,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "institutionEmail": institutionEmail,
        "gender": gender,
        "age": age,
        "role": role,
      };
}
