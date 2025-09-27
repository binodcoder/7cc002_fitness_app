import 'dart:convert';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

// Data-layer DTOs (do not extend domain). Provide JSON parsing and mapping.

SyncDto syncDtoFromJsonStr(String str) => SyncDto.fromJson(json.decode(str));
String syncDtoToJsonStr(SyncDto dto) => json.encode(dto.toJson());

class SyncDto {
  final SyncDataDto data;

  const SyncDto({required this.data});

  factory SyncDto.fromJson(Map<String, dynamic> json) {
    final dataMap = (json['data'] as Map?)?.cast<String, dynamic>() ?? const {};
    return SyncDto(data: SyncDataDto.fromJson(dataMap));
  }

  factory SyncDto.fromEntity(SyncEntity e) =>
      SyncDto(data: SyncDataDto.fromEntity(e.data));

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };

  SyncEntity toEntity() => SyncEntity(data: data.toEntity());
}

class SyncDataDto {
  final List<TrainerDto> trainers;
  final CompanyDto company;
  final String message;

  const SyncDataDto(
      {required this.trainers, required this.company, required this.message});

  factory SyncDataDto.fromJson(Map<String, dynamic> json) {
    final trainersList = (json['trainers'] as List?) ?? const [];
    return SyncDataDto(
      trainers: trainersList
          .whereType<dynamic>()
          .map((e) => TrainerDto.fromJson(
              (e as Map?)?.cast<String, dynamic>() ?? const {}))
          .toList(),
      company:
          CompanyDto.fromJson((json['company'] as Map?)?.cast<String, dynamic>() ?? const {}),
      message: (json['message'] ?? '').toString(),
    );
  }

  factory SyncDataDto.fromEntity(SyncDataEntity e) => SyncDataDto(
        trainers: e.trainers.map((t) => TrainerDto.fromEntity(t)).toList(),
        company: CompanyDto.fromEntity(e.company),
        message: e.message,
      );

  Map<String, dynamic> toJson() => {
        'trainers': trainers.map((e) => e.toJson()).toList(),
        'company': company.toJson(),
        'message': message,
      };

  SyncDataEntity toEntity() => SyncDataEntity(
        trainers: trainers.map((t) => t.toEntity()).toList(),
        company: company.toEntity(),
        message: message,
      );
}

class CompanyDto {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  const CompanyDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory CompanyDto.fromJson(Map<String, dynamic> json) => CompanyDto(
        id: _asInt(json['id']),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        phone: (json['phone'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
      );

  factory CompanyDto.fromEntity(CompanyEntity e) => CompanyDto(
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

  CompanyEntity toEntity() => CompanyEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );
}

class TrainerDto {
  final int id;
  final String name;
  final String email;
  final String password;
  final String institutionEmail;
  final String gender;
  final int age;
  final String role;

  const TrainerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.institutionEmail,
    required this.gender,
    required this.age,
    required this.role,
  });

  factory TrainerDto.fromJson(Map<String, dynamic> json) => TrainerDto(
        id: _asInt(json['id']),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        password: (json['password'] ?? '').toString(),
        institutionEmail: (json['institutionEmail'] ?? '').toString(),
        gender: (json['gender'] ?? '').toString(),
        age: _asInt(json['age']),
        role: (json['role'] ?? '').toString(),
      );

  factory TrainerDto.fromEntity(TrainerEntity e) => TrainerDto(
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

  TrainerEntity toEntity() => TrainerEntity(
        id: id,
        name: name,
        email: email,
        password: password,
        institutionEmail: institutionEmail,
        gender: gender,
        age: age,
        role: role,
      );
}

int _asInt(dynamic v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v) ?? 0;
  if (v is num) return v.toInt();
  return 0;
}
