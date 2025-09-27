import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';
import 'package:fitness_app/features/appointment/data/repositories/appointment_repositories_impl.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/errors/exceptions.dart';

class FakeOkRemote implements AppointmentRemoteDataSource {
  List<AppointmentModel> items = const [];
  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) async => 1;
  @override
  Future<int> deleteAppointment(int appointmentId) async => 1;
  @override
  Future<List<AppointmentModel>> getAppointments() async => items;
  @override
  Future<int> updateAppointment(AppointmentModel appointmentModel) async => 1;
}

class FakeFailRemote implements AppointmentRemoteDataSource {
  @override
  Future<int> addAppointment(AppointmentModel appointmentModel) async => throw ServerException();
  @override
  Future<int> deleteAppointment(int appointmentId) async => throw ServerException();
  @override
  Future<List<AppointmentModel>> getAppointments() async => throw ServerException();
  @override
  Future<int> updateAppointment(AppointmentModel appointmentModel) async => throw ServerException();
}

void main() {
  final entity = Appointment(
    id: 1,
    date: DateTime(2025, 1, 1),
    startTime: '09:00',
    endTime: '10:00',
    trainerId: 2,
    userId: 3,
    remark: 'r',
  );

  test('returns Right on remote success', () async {
    final repo = AppointmentRepositoriesImpl(appointmentRemoteDataSource: FakeOkRemote());
    expect(await repo.addAppointment(entity), const Right(1));
    expect(await repo.updateAppointment(entity), const Right(1));
    expect(await repo.deleteAppointment(1), const Right(1));
    final res = await repo.getAppointments();
    expect(res!.isRight(), true);
  });

  test('returns Left on remote failure', () async {
    final repo = AppointmentRepositoriesImpl(appointmentRemoteDataSource: FakeFailRemote());
    expect(await repo.addAppointment(entity), Left(ServerFailure()));
    expect(await repo.updateAppointment(entity), Left(ServerFailure()));
    expect(await repo.deleteAppointment(1), Left(ServerFailure()));
    expect(await repo.getAppointments(), Left(ServerFailure()));
  });
}
