// To parse this JSON data, do
//
//     final walkModel = walkModelFromJson(jsonString);

import 'dart:convert';

List<WalkModel> walkModelFromJson(String str) =>
    List<WalkModel>.from(json.decode(str).map((x) => WalkModel.fromJson(x)));

String walkModelToJson(List<WalkModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalkModel {
  int id;
  int proposerId;
  String routeData;
  DateTime date;
  String startTime;
  String startLocation;
  List<Participant> participants;

  WalkModel({
    required this.id,
    required this.proposerId,
    required this.routeData,
    required this.date,
    required this.startTime,
    required this.startLocation,
    required this.participants,
  });

  factory WalkModel.fromJson(Map<String, dynamic> json) => WalkModel(
        id: json["id"],
        proposerId: json["proposerId"],
        routeData: json["routeData"],
        date: DateTime.parse(json["date"]),
        startTime: json["startTime"],
        startLocation: json["startLocation"],
        participants: List<Participant>.from(
            json["participants"].map((x) => Participant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "proposerId": proposerId,
        "routeData": routeData,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "startTime": startTime,
        "startLocation": startLocation,
        "participants": List<dynamic>.from(participants.map((x) => x.toJson())),
      };
}

class Participant {
  int id;
  String name;
  String email;
  String password;
  String institutionEmail;
  String gender;
  int age;
  String role;

  Participant({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.institutionEmail,
    required this.gender,
    required this.age,
    required this.role,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        institutionEmail: json["institutionEmail"],
        gender: json["gender"],
        age: json["age"],
        role: json["role"],
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
