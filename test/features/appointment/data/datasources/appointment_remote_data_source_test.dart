import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

void main() {
  group('AppointmentRemoteDataSource', () {
    test('getAppointments returns list on 200', () async {
      final client = MockClient((request) async {
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'date': '2025-01-01',
              'startTime': '09:00',
              'endTime': '10:00',
              'trainerId': 2,
              'userId': 3,
              'remark': 'r'
            }
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final ds = AppointmentRemoteDataSourceImpl(client: client);
      final res = await ds.getAppointments();
      expect(res, isA<List<AppointmentModel>>());
      expect(res.length, 1);
    });

    test('getAppointments throws on non-200', () async {
      final ds = AppointmentRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 500)));
      expect(() => ds.getAppointments(), throwsA(isA<ServerException>()));
    });

    test('add/update/delete return success codes', () async {
      final clientCreated = MockClient((_) async => http.Response('', 201));
      final clientOk = MockClient((_) async => http.Response('', 200));
      final dsCreated = AppointmentRemoteDataSourceImpl(client: clientCreated);
      final dsOk = AppointmentRemoteDataSourceImpl(client: clientOk);
      final model = AppointmentModel(
        id: 1,
        date: DateTime(2025, 1, 1),
        startTime: '09:00',
        endTime: '10:00',
        trainerId: 2,
        userId: 3,
        remark: 'r',
      );
      expect(await dsCreated.addAppointment(model), 1);
      expect(await dsOk.updateAppointment(model), 1);
      expect(await dsOk.deleteAppointment(1), 1);
    });
  });
}
