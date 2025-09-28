import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../domain/repositories/appointment_repositories.dart';

class AppointmentRepositoriesImpl implements AppointmentRepositories {
  final AppointmentDataSource appointmentRemoteDataSource;

  AppointmentRepositoriesImpl({
    required this.appointmentRemoteDataSource,
  });

  @override
  Future<Either<Failure, int>>? addAppointment(Appointment appointment) async {
    try {
      final model = AppointmentModel.fromEntity(appointment);
      int response = await appointmentRemoteDataSource.addAppointment(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateAppointment(
      Appointment appointment) async {
    try {
      final model = AppointmentModel.fromEntity(appointment);
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
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
