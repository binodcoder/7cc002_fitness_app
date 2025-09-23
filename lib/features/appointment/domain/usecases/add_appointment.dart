import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/appointment_repositories.dart';

class AddAppointment implements UseCase<int, Appointment> {
  final  AppointmentRepositories addAppointmentRepositories;

  AddAppointment(this.addAppointmentRepositories);

  @override
  Future<Either<Failure, int>?> call(Appointment appointmentModel) async {
    return await addAppointmentRepositories.addAppointment(appointmentModel);
  }
}
