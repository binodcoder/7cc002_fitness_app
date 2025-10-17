import 'dart:convert';
import 'package:fitness_app/core/entities/user.dart' as entity;

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends entity.User {
  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.institutionEmail,
    required super.gender,
    required super.age,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json["id"] as num?)?.toInt() ?? 0,
        name: (json["name"] as String?) ?? '',
        email: (json["email"] as String?) ?? '',
        password: (json["password"] as String?) ?? '',
        institutionEmail: (json["institutionEmail"] as String?) ?? '',
        gender: (json["gender"] as String?) ?? '',
        age: (json["age"] as num?)?.toInt() ?? 0,
        role: (json["role"] as String?) ?? 'standard',
      );

  factory UserModel.fromEntity(entity.User e) => UserModel(
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
