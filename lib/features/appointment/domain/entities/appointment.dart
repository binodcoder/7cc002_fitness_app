import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final DateTime date;
  final String endTime;
  final int? id;
  final String startTime;
  final int trainerId;
  final int userId;
  final String? remark;

  const Appointment({
    required this.date,
    required this.endTime,
    this.id,
    required this.startTime,
    required this.trainerId,
    required this.userId,
    this.remark,
  });

  @override
  List<Object?> get props => [id, date, startTime, endTime, trainerId, userId, remark];
}

