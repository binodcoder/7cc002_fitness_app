// To parse this JSON data, do
//
//     final syncModel = syncModelFromJson(jsonString);

import 'dart:convert';

SyncModel syncModelFromJson(String str) => SyncModel.fromJson(json.decode(str));

String syncModelToJson(SyncModel data) => json.encode(data.toJson());

class SyncModel {
  Data data;
  String message;

  SyncModel({
    required this.data,
    required this.message,
  });

  factory SyncModel.fromJson(Map<String, dynamic> json) => SyncModel(
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  List<Trainer> trainers;

  Data({
    required this.trainers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    trainers: List<Trainer>.from(
        json["trainers"].map((x) => Trainer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "trainers": List<dynamic>.from(trainers.map((x) => x.toJson())),
  };
}

class Trainer {
  int? id;
  String? name;
  String? email;
  String? password;
  String? institutionEmail;
  String? gender;
  int? age;
  String? role;

  Trainer({
    this.id,
    this.name,
    this.email,
    this.password,
    this.institutionEmail,
    this.gender,
    this.age,
    this.role,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) => Trainer(
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
