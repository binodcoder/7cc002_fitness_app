import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id; // numeric id assigned in users collection (optional)
  final String email;
  final String password;
  final String role;

  const User({
    this.id,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [id, email, password, role];
}
