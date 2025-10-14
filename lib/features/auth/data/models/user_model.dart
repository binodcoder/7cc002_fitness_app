import 'dart:convert';
import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends entity.User {
  const UserModel({
    super.id,
    required super.email,
    required super.password,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json["id"] as num?)?.toInt(),
        email: (json["email"] as String?) ?? '',
        password: (json["password"] as String?) ?? '',
        role: (json["role"] as String?) ?? 'standard',
      );

  factory UserModel.fromEntity(entity.User e) => UserModel(
        id: e.id,
        email: e.email,
        password: e.password,
        role: e.role,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "role": role,
      };
}
