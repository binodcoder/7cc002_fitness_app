// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int age;
  String email;
  String gender;
  int? id;
  String institutionEmail;
  String name;
  String password;
  String role;

  UserModel({
    required this.age,
    required this.email,
    required this.gender,
    this.id,
    required this.institutionEmail,
    required this.name,
    required this.password,
    required this.role,
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
