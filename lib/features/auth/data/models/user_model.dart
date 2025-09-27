// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';
import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends entity.User {
  const UserModel({
    required super.age,
    required super.email,
    required super.gender,
    super.id,
    required super.institutionEmail,
    required super.name,
    required super.password,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        age: json["age"],
        email: json["email"],
        gender: json["gender"],
        id: json["id"],
        institutionEmail: json["institutionEmail"],
        name: json["name"],
        password: json["password"],
        role: json["role"],
      );

  factory UserModel.fromEntity(entity.User e) => UserModel(
        age: e.age,
        email: e.email,
        gender: e.gender,
        id: e.id,
        institutionEmail: e.institutionEmail,
        name: e.name,
        password: e.password,
        role: e.role,
      );

  Map<String, dynamic> toJson() => {
        "age": age,
        "email": email,
        "gender": gender,
        "id": id,
        "institutionEmail": institutionEmail,
        "name": name,
        "password": password,
        "role": role,
      };
}
