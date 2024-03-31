import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';

abstract class AppointmentRepositories {
  Future<Either<Failure, List<AppointmentModel>>>? getAppointments();
  Future<Either<Failure, int>>? addAppointment(
      AppointmentModel appointmentModel);
  Future<Either<Failure, int>>? updateAppointment(AppointmentModel userModel);
  Future<Either<Failure, int>>? deleteAppointment(int appointmentId);
}
