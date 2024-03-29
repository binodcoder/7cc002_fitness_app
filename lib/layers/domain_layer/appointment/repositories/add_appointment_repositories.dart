import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';

abstract class AddAppointmentRepositories {
  Future<Either<Failure, int>>? addAppointment(AppointmentModel  appointmentModel);
}
