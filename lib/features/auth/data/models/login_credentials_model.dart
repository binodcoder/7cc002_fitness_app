import 'dart:convert';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';

LoginCredentialsModel loginModelFromJson(String str) =>
    LoginCredentialsModel.fromJson(json.decode(str));

String loginModelToJson(LoginCredentialsModel data) =>
    json.encode(data.toJson());

class LoginCredentialsModel extends LoginCredentials {
  const LoginCredentialsModel({required super.email, required super.password});

  factory LoginCredentialsModel.fromJson(Map<String, dynamic> json) =>
      LoginCredentialsModel(email: json["email"], password: json["password"]);

  factory LoginCredentialsModel.fromEntity(LoginCredentials e) =>
      LoginCredentialsModel(email: e.email, password: e.password);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}
