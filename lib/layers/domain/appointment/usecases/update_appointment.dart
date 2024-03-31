import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repositories.dart';

class UpdateAppointment implements UseCase<int, AppointmentModel> {
  AppointmentRepositories appointmentRepository;

  UpdateAppointment(this.appointmentRepository);

  @override
  Future<Either<Failure, int>?> call(AppointmentModel appointmentModel) async {
    return await appointmentRepository.updateAppointment(appointmentModel);
  }
}
