// To parse this JSON data, do
//
//     final syncModel = syncModelFromJson(jsonString);

import 'dart:convert';

SyncModel syncModelFromJson(String str) => SyncModel.fromJson(json.decode(str));

String syncModelToJson(SyncModel data) => json.encode(data.toJson());

class SyncModel {
  Data data;

  SyncModel({
    required this.data,
  });

  factory SyncModel.fromJson(Map<String, dynamic> json) => SyncModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  List<Trainer> trainers;
  Company company;
  String message;

  Data({
    required this.trainers,
    required this.company,
    required this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    trainers: List<Trainer>.from(json["trainers"].map((x) => Trainer.fromJson(x))),
    company: Company.fromJson(json["company"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "trainers": List<dynamic>.from(trainers.map((x) => x.toJson())),
    "company": company.toJson(),
    "message": message,
  };
}

class Company {
  int id;
  String name;
  String email;
  String phone;
  String address;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
  };
}

class Trainer {
  int id;
  String name;
  String email;
  String password;
  String institutionEmail;
  String gender;
  int age;
  String role;

  Trainer({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.institutionEmail,
    required this.gender,
    required this.age,
    required this.role,
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
