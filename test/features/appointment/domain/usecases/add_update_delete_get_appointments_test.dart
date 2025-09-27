import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/appointment/domain/repositories/appointment_repositories.dart';
import 'package:fitness_app/features/appointment/domain/usecases/add_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/update_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/delete_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/get_appointments.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepositories {}

void main() {
  final repo = MockAppointmentRepository();
  final addUse = AddAppointment(repo);
  final updateUse = UpdateAppointment(repo);
  final delUse = DeleteAppointment(repo);
  final getUse = GetAppointments(repo);

  final entity = Appointment(
    id: 1,
    date: DateTime(2025, 1, 1),
    startTime: '09:00',
    endTime: '10:00',
    trainerId: 2,
    userId: 3,
    remark: 'r',
  );

  test('add/update/delete/get', () async {
    when(repo.addAppointment(entity)).thenAnswer((_) async => const Right(1));
    when(repo.updateAppointment(entity)).thenAnswer((_) async => const Right(1));
    when(repo.deleteAppointment(1)).thenAnswer((_) async => const Right(1));
    when(repo.getAppointments()).thenAnswer((_) async => Right([entity]));

    expect(await addUse(entity), const Right(1));
    expect(await updateUse(entity), const Right(1));
    expect(await delUse(1), const Right(1));
    final res = await getUse(NoParams());
    expect(res, isNotNull);
    res!.fold((l) => fail('Expected Right'), (r) => expect(r, [entity]));
  });
}
