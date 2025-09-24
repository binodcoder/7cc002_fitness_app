import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../domain/repositories/appointment_repositories.dart';
import '../datasources/appointment_remote_data_source.dart';

class AppointmentRepositoriesImpl implements AppointmentRepositories {
  final AppointmentRemoteDataSource appointmentRemoteDataSource;

  AppointmentRepositoriesImpl({
    required this.appointmentRemoteDataSource,
  });

  @override
  Future<Either<Failure, int>>? addAppointment(
      Appointment appointmentModel) async {
    try {
      final model = appointmentModel is AppointmentModel
          ? appointmentModel
          : AppointmentModel.fromEntity(appointmentModel);
      int response = await appointmentRemoteDataSource.addAppointment(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateAppointment(
      Appointment appointmentModel) async {
    try {
      final model = appointmentModel is AppointmentModel
          ? appointmentModel
          : AppointmentModel.fromEntity(appointmentModel);
      int response = await appointmentRemoteDataSource.updateAppointment(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteAppointment(int appointmentId) async {
    try {
      int response =
          await appointmentRemoteDataSource.deleteAppointment(appointmentId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>>? getAppointments() async {
    try {
      List<AppointmentModel> response =
          await appointmentRemoteDataSource.getAppointments();
      return Right(response.cast<Appointment>());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
