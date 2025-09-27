import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/live_training/data/datasources/live_training_remote_data_source.dart';
import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';

void main() {
  group('LiveTrainingRemoteDataSource', () {
    test('getLiveTrainings returns list on 200', () async {
      final client = MockClient((_) async => http.Response(jsonEncode([
        {
          'trainerId': 1,
          'title': 't',
          'description': 'd',
          'trainingDate': '2025-01-01',
          'startTime': '09:00',
          'endTime': '10:00',
        }
      ]), 200, headers: {'content-type':'application/json'}));
      final ds = LiveTrainingRemoteDataSourceImpl(client: client);
      final res = await ds.getLiveTrainings();
      expect(res, isA<List<LiveTrainingModel>>());
    });

    test('add/update/delete status', () async {
      final dsCreated = LiveTrainingRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 201)));
      final dsOk = LiveTrainingRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 200)));
      final model = LiveTrainingModel(
        trainerId: 1,
        title: 't',
        description: 'd',
        trainingDate: DateTime(2025, 1, 1),
        startTime: '09:00',
        endTime: '10:00',
      );
      expect(await dsCreated.addLiveTraining(model), 1);
      expect(await dsOk.updateLiveTraining(model), 1);
      expect(await dsOk.deleteLiveTraining(1), 1);
    });

    test('throws on error', () async {
      final ds = LiveTrainingRemoteDataSourceImpl(client: MockClient((_) async => http.Response('', 500)));
      expect(() => ds.getLiveTrainings(), throwsA(isA<ServerException>()));
    });
  });
}
