import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../domain_layer/appointment/repositories/add_appointment_repositories.dart';
import '../../../domain_layer/register/repositories/add_user_repositories.dart';
 import '../datasources/add_appointment_remote_data_source.dart';

class AddAppointmentRepositoriesImpl implements AddAppointmentRepositories {
  final AddAppointmentToRemoteDataSource addAppointmentToRemoteDataSource;

  AddAppointmentRepositoriesImpl({required this.addAppointmentToRemoteDataSource,  });

  @override
  Future<Either<Failure, int>>? addAppointment(AppointmentModel  appointmentModel) async {
    try {
      int response = await addAppointmentToRemoteDataSource.addAppointment(appointmentModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
