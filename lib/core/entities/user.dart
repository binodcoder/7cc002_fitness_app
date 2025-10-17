import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String institutionEmail;
  final String gender;
  final int age;
  final String role;

  const User({
    this.id,
    this.name = '',
    required this.email,
    required this.password,
    this.institutionEmail = '',
    this.gender = '',
    this.age = 0,
    required this.role,
  });

  @override
  List<Object?> get props =>
      [id, name, email, password, institutionEmail, gender, age, role];
}
