import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int age;
  final String email;
  final String gender;
  final int? id;
  final String institutionEmail;
  final String name;
  final String password;
  final String role;

  const User({
    required this.age,
    required this.email,
    required this.gender,
    this.id,
    required this.institutionEmail,
    required this.name,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [id, age, email, gender, institutionEmail, name, password, role];
}

