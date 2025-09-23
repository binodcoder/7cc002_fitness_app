import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/appointment_repositories.dart';

class UpdateAppointment implements UseCase<int, Appointment> {
  AppointmentRepositories appointmentRepository;

  UpdateAppointment(this.appointmentRepository);

  @override
  Future<Either<Failure, int>?> call(Appointment appointmentModel) async {
    return await appointmentRepository.updateAppointment(appointmentModel);
  }
}
