// To parse this JSON data, do
//
//     final syncModel = syncModelFromJson(jsonString);

import 'dart:convert';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

// Decode JSON into a domain entity via model adapters
SyncEntity syncModelFromJson(String str) =>
    SyncModel.fromJson(json.decode(str));

// Encode any SyncEntity to JSON using the model adapter
String syncModelToJson(SyncEntity data) => json.encode(
    (data is SyncModel ? data : SyncModel.fromEntity(data)).toJson());

class SyncModel extends SyncEntity {
  const SyncModel({required super.data});

  factory SyncModel.fromJson(Map<String, dynamic> json) =>
      SyncModel(data: SyncDataModel.fromJson(json["data"]));

  factory SyncModel.fromEntity(SyncEntity e) =>
      SyncModel(data: SyncDataModel.fromEntity(e.data));

  Map<String, dynamic> toJson() => {"data": (data as SyncDataModel).toJson()};
}

class SyncDataModel extends SyncDataEntity {
  const SyncDataModel(
      {required super.trainers,
      required super.company,
      required super.message});

  factory SyncDataModel.fromJson(Map<String, dynamic> json) => SyncDataModel(
        trainers: List<TrainerModel>.from(
            json["trainers"].map((x) => TrainerModel.fromJson(x))),
        company: CompanyModel.fromJson(json["company"]),
        message: json["message"],
      );

  factory SyncDataModel.fromEntity(SyncDataEntity e) => SyncDataModel(
        trainers: e.trainers.map((t) => TrainerModel.fromEntity(t)).toList(),
        company: CompanyModel.fromEntity(e.company),
        message: e.message,
      );

  Map<String, dynamic> toJson() => {
        "trainers": trainers.map((x) => (x as TrainerModel).toJson()).toList(),
        "company": (company as CompanyModel).toJson(),
        "message": message,
      };
}

class CompanyModel extends CompanyEntity {
  const CompanyModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.phone,
      required super.address});

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  factory CompanyModel.fromEntity(CompanyEntity e) => CompanyModel(
      id: e.id,
      name: e.name,
      email: e.email,
      phone: e.phone,
      address: e.address);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address
      };
}

class TrainerModel extends TrainerEntity {
  const TrainerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.institutionEmail,
    required super.gender,
    required super.age,
    required super.role,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> json) => TrainerModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        institutionEmail: json["institutionEmail"],
        gender: json["gender"],
        age: json["age"],
        role: json["role"],
      );

  factory TrainerModel.fromEntity(TrainerEntity e) => TrainerModel(
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
