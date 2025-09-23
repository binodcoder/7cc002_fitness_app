import 'dart:convert';
import 'package:fitness_app/features/login/domain/entities/login.dart' as entity;

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel extends entity.Login {
  const LoginModel({required super.email, required super.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) =>
      LoginModel(email: json["email"], password: json["password"]);

  factory LoginModel.fromEntity(entity.Login e) =>
      LoginModel(email: e.email, password: e.password);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
