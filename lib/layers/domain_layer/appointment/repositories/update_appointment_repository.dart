import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/failures.dart';

abstract class UpdateAppointmentRepository {
  Future<Either<Failure, int>>? updateAppointment(AppointmentModel userModel);
}
