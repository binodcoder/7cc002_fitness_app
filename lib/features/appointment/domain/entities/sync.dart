import 'package:equatable/equatable.dart';

class SyncEntity extends Equatable {
  final SyncDataEntity data;

  const SyncEntity({required this.data});

  @override
  List<Object?> get props => [data];
}

class SyncDataEntity extends Equatable {
  final List<TrainerEntity> trainers;
  final CompanyEntity company;
  final String message;

  const SyncDataEntity(
      {required this.trainers, required this.company, required this.message});

  @override
  List<Object?> get props => [trainers, company, message];
}

class CompanyEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  const CompanyEntity(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.address});

  @override
  List<Object?> get props => [id, name, email, phone, address];
}

class TrainerEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String password;
  final String institutionEmail;
  final String gender;
  final int age;
  final String role;

  const TrainerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.institutionEmail,
    required this.gender,
    required this.age,
    required this.role,
  });

  @override
  List<Object?> get props =>
      [id, name, email, password, institutionEmail, gender, age, role];
}
