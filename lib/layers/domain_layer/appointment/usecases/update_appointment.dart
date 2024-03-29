import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/update_appointment_repository.dart';

class UpdateAppointment implements UseCase<int, AppointmentModel> {
  UpdateAppointmentRepository updateAppointmentRepository;

  UpdateAppointment(this.updateAppointmentRepository);

  @override
  Future<Either<Failure, int>?> call(AppointmentModel appointmentModel) async {
    return await updateAppointmentRepository
        .updateAppointment(appointmentModel);
  }
}
