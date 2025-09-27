import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('AppDatabase initializes and has routine table', () async {
    final db = await AppDatabase().database;
    // Expect query on routine table to succeed (empty rows at fresh DB)
    final rows = await db.query('routine');
    expect(rows, isA<List<Map<String, Object?>>>());
  });
}

