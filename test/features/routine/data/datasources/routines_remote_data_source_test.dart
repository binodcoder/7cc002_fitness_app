import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/features/routine/data/data_sources/routines_remote_data_source.dart';

void main() {
  group('RoutineRemoteDataSource', () {
    test('getRoutines returns list on 200', () async {
      final client = MockClient((request) async {
        expect(request.method, equals('GET'));
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'name': 'A',
              'description': 'desc',
              'difficulty': 'easy',
              'duration': 12,
              'source': 'pre_loaded',
            }
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final ds = RoutineRemoteDataSourceImpl(client: client);
      final result = await ds.getRoutines();
      expect(result, isA<List<RoutineModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'A');
    });

    test('getRoutines throws on non-200', () async {
      final client = MockClient((request) async => http.Response('oops', 500));
      final ds = RoutineRemoteDataSourceImpl(client: client);
      expect(() => ds.getRoutines(), throwsA(isA<ServerException>()));
    });

    test('addRoutine returns 1 on 201', () async {
      final client = MockClient((request) async {
        expect(request.method, equals('POST'));
        return http.Response('', 201);
      });
      final ds = RoutineRemoteDataSourceImpl(client: client);
      const model = RoutineModel(
        id: 1,
        name: 'A',
        description: 'desc',
        difficulty: 'easy',
        duration: 12,
        source: 'pre_loaded',
      );
      final result = await ds.addRoutine(model);
      expect(result, 1);
    });

    test('addRoutine throws on non-201', () async {
      final client = MockClient((request) async => http.Response('', 400));
      final ds = RoutineRemoteDataSourceImpl(client: client);
      const model = RoutineModel(
        id: 1,
        name: 'A',
        description: 'desc',
        difficulty: 'easy',
        duration: 12,
        source: 'pre_loaded',
      );
      expect(() => ds.addRoutine(model), throwsA(isA<ServerException>()));
    });

    test('updateRoutine returns 1 on 200', () async {
      final client = MockClient((request) async {
        expect(request.method, equals('PUT'));
        return http.Response('', 200);
      });
      final ds = RoutineRemoteDataSourceImpl(client: client);
      const model = RoutineModel(
        id: 1,
        name: 'A',
        description: 'desc',
        difficulty: 'easy',
        duration: 12,
        source: 'pre_loaded',
      );
      final result = await ds.updateRoutine(model);
      expect(result, 1);
    });

    test('updateRoutine throws on non-200', () async {
      final client = MockClient((request) async => http.Response('', 500));
      final ds = RoutineRemoteDataSourceImpl(client: client);
      const model = RoutineModel(
        id: 1,
        name: 'A',
        description: 'desc',
        difficulty: 'easy',
        duration: 12,
        source: 'pre_loaded',
      );
      expect(() => ds.updateRoutine(model), throwsA(isA<ServerException>()));
    });

    test('deleteRoutine returns 1 on 200', () async {
      final client = MockClient((request) async {
        expect(request.method, equals('DELETE'));
        return http.Response('', 200);
      });
      final ds = RoutineRemoteDataSourceImpl(client: client);
      final result = await ds.deleteRoutine(1);
      expect(result, 1);
    });

    test('deleteRoutine throws on non-200', () async {
      final client = MockClient((request) async => http.Response('', 404));
      final ds = RoutineRemoteDataSourceImpl(client: client);
      expect(() => ds.deleteRoutine(1), throwsA(isA<ServerException>()));
    });
  });
}

