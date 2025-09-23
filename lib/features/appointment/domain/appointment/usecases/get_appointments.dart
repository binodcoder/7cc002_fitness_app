import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/appointment_repositories.dart';

class GetAppointments implements UseCase<List<AppointmentModel>, NoParams> {
  final AppointmentRepositories appointmentRepositories;

  GetAppointments(this.appointmentRepositories);

  @override
  Future<Either<Failure, List<AppointmentModel>>?> call(NoParams noParams) async {
    return await appointmentRepositories.getAppointments();
  }
}
