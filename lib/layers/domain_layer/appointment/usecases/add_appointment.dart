import 'package:fitness_app/core/model/appointment_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/add_appointment_repositories.dart';

class AddAppointment implements UseCase<int, AppointmentModel> {
  final AddAppointmentRepositories addAppointmentRepositories;

  AddAppointment(this.addAppointmentRepositories);

  @override
  Future<Either<Failure, int>?> call(AppointmentModel appointmentModel) async {
    return await addAppointmentRepositories.addAppointment(appointmentModel);
  }
}
