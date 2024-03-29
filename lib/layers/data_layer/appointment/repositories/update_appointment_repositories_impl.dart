import 'package:dartz/dartz.dart';
import 'package:fitness_app/layers/domain_layer/appointment/repositories/update_appointment_repository.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/appointment_model.dart';
import '../datasources/update_appointment_remote_data_sources.dart';

class UpdateAppointmentRepositoriesImpl implements UpdateAppointmentRepository {
  UpdateAppointmentRemoteDataSources updateAppointmentRemoteDataSources;
  UpdateAppointmentRepositoriesImpl(
      {required this.updateAppointmentRemoteDataSources});

  @override
  Future<Either<Failure, int>>? updateAppointment(
      AppointmentModel appointmentModel) async {
    try {
      int response = await updateAppointmentRemoteDataSources
          .updateAppointment(appointmentModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
