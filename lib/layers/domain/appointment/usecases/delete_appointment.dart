import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/appointment_repositories.dart';

class DeleteAppointment implements UseCase<int, int> {
  AppointmentRepositories appointmentRepository;

  DeleteAppointment(this.appointmentRepository);

  @override
  Future<Either<Failure, int>?> call(int appointmentId) async {
    return await appointmentRepository.deleteAppointment(appointmentId);
  }
}
