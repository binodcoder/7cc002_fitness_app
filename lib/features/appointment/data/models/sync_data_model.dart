import 'dart:convert';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

// Keep Model naming and extend domain entities, while keeping robust parsing.

// Decode JSON string to a data-layer model (which extends domain entity)
SyncModel syncModelFromJson(String str) =>
    SyncModel.fromJson(json.decode(str) as Map<String, dynamic>);

// Encode model to JSON string
String syncModelToJson(SyncModel data) => json.encode(data.toJson());

class SyncModel extends SyncEntity {
  const SyncModel({required super.data});

  factory SyncModel.fromJson(Map<String, dynamic> json) => SyncModel(
        data: SyncDataModel.fromJson(
            (json['data'] as Map?)?.cast<String, dynamic>() ?? const {}),
      );

  factory SyncModel.fromEntity(SyncEntity e) =>
      SyncModel(data: SyncDataModel.fromEntity(e.data));

  Map<String, dynamic> toJson() => {
        'data': (data as SyncDataModel).toJson(),
      };
}

class SyncDataModel extends SyncDataEntity {
  const SyncDataModel({
    required super.trainers,
    required super.company,
    required super.message,
  });

  factory SyncDataModel.fromJson(Map<String, dynamic> json) {
    final trainersList = (json['trainers'] as List?) ?? const [];
    return SyncDataModel(
      trainers: trainersList
          .whereType<dynamic>()
          .map((e) => TrainerModel.fromJson(
              (e as Map?)?.cast<String, dynamic>() ?? const {}))
          .toList(),
      company: CompanyModel.fromJson(
          (json['company'] as Map?)?.cast<String, dynamic>() ?? const {}),
      message: (json['message'] ?? '').toString(),
    );
  }

  factory SyncDataModel.fromEntity(SyncDataEntity e) => SyncDataModel(
        trainers: e.trainers.map((t) => TrainerModel.fromEntity(t)).toList(),
        company: CompanyModel.fromEntity(e.company),
        message: e.message,
      );

  Map<String, dynamic> toJson() => {
        'trainers': trainers.map((e) => (e as TrainerModel).toJson()).toList(),
        'company': (company as CompanyModel).toJson(),
        'message': message,
      };
}

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: _asInt(json['id']),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        phone: (json['phone'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
      );

  factory CompanyModel.fromEntity(CompanyEntity e) => CompanyModel(
        id: e.id,
        name: e.name,
        email: e.email,
        phone: e.phone,
        address: e.address,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
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
        id: _asInt(json['id']),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        password: (json['password'] ?? '').toString(),
        institutionEmail: (json['institutionEmail'] ?? '').toString(),
        gender: (json['gender'] ?? '').toString(),
        age: _asInt(json['age']),
        role: (json['role'] ?? '').toString(),
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
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'institutionEmail': institutionEmail,
        'gender': gender,
        'age': age,
        'role': role,
      };
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  if (v is num) return v.toInt();
  return 0;
}
