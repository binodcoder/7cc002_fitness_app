import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_local_data_sources.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('AuthLocalDataSources add and update user', () async {
    final db = await AppDatabase().database;
    final ds = AuthLocalDataSourcesImpl(db: db);
    const user = UserModel(
      name: 'n',
      email: 'e',
      password: 'p',
      age: 1,
      gender: 'g',
      institutionEmail: 'i',
      role: 'r',
    );
    final id = await ds.addUser(user);
    expect(id, isNonZero);
    final updated = await ds.updateUser(UserModel(
      id: id,
      name: 'n2',
      email: 'e',
      password: 'p',
      age: 1,
      gender: 'g',
      institutionEmail: 'i',
      role: 'r',
    ));
    expect(updated, 1);
  });
}
