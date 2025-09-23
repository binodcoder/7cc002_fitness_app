import 'package:equatable/equatable.dart';

class Walk extends Equatable {
  final int? id;
  final int proposerId;
  final String routeData;
  final DateTime date;
  final String startTime;
  final String startLocation;
  final List<Participant> participants;

  const Walk({
    this.id,
    required this.proposerId,
    required this.routeData,
    required this.date,
    required this.startTime,
    required this.startLocation,
    this.participants = const [],
  });

  @override
  List<Object?> get props => [id, proposerId, routeData, date, startTime, startLocation, participants];
}

class Participant extends Equatable {
  final int id;
  final String name;
  final String email;
  final String password;
  final String institutionEmail;
  final String gender;
  final int age;
  final String role;

  const Participant({
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
  List<Object?> get props => [id, name, email, password, institutionEmail, gender, age, role];
}

class WalkParticipant extends Equatable {
  final int userId;
  final int walkId;

  const WalkParticipant({required this.userId, required this.walkId});

  @override
  List<Object?> get props => [userId, walkId];
}

