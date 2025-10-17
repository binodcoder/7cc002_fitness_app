import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/home/data/data_sources/home_local_data_source.dart';
import 'package:fitness_app/features/home/data/models/routine_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late RoutinesLocalDataSourceImpl dataSource;

  setUpAll(() {
    // Use FFI for sqflite in unit tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    final db = await AppDatabase().database;
    dataSource = RoutinesLocalDataSourceImpl(db);
  });

  group('RoutinesLocalDataSource with AppDatabase', () {
    final tRoutineModel =
        RoutineModel.fromJson(json.decode(fixture('routine_cached.json')));

    test('should cache and retrieve routines', () async {
      await dataSource.clearRoutines();
      await dataSource.cacheRoutine(tRoutineModel);
      final result = await dataSource.getLastRoutines();
      expect(result.isNotEmpty, true);
      expect(result.first.name, tRoutineModel.name);
    });
  });
}
