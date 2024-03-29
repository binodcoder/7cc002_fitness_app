import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../domain_layer/appointment/repositories/appointment_repositories.dart';
import '../../../domain_layer/register/repositories/user_repositories.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentRepositoriesImpl implements AppointmentRepositories {
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  AppointmentRepositoriesImpl({
    required this.appointmentRemoteDataSource,
  });

  @override
  Future<Either<Failure, int>>? addAppointment(
      AppointmentModel appointmentModel) async {
    try {
      int response =
          await appointmentRemoteDataSource.addAppointment(appointmentModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateAppointment(
      AppointmentModel appointmentModel) async {
    try {
      int response =
          await appointmentRemoteDataSource.updateAppointment(appointmentModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteAppointment(int appointmentId) async {
    try {
      int response =
          await appointmentRemoteDataSource.deleteAppointment(appointmentId);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>>? getAppointments() async {
    try {
      List<AppointmentModel> response =
          await appointmentRemoteDataSource.getAppointments();
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
