import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/failures.dart';

abstract class AppointmentRepositories {
  Future<Either<Failure, List<Appointment>>>? getAppointments();
  Future<Either<Failure, int>>? addAppointment(Appointment appointmentModel);
  Future<Either<Failure, int>>? updateAppointment(Appointment userModel);
  Future<Either<Failure, int>>? deleteAppointment(int appointmentId);
}
