import 'package:fitness_app/features/auth/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class AuthLocalDataSources {
  Future<int> addUser(UserModel userModel);
  Future<int> updateUser(UserModel userModel);
}

class AuthLocalDataSourcesImpl extends AuthLocalDataSources {
  final Database db;
  AuthLocalDataSourcesImpl({required this.db});
  @override
  Future<int> addUser(UserModel userModel) => _postUserToLocal(userModel);

  Future<int> _postUserToLocal(UserModel userModel) async {
    return db.insert(
      'users',
      userModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<int> updateUser(UserModel userModel) => _updateUserToLocal(userModel);

  Future<int> _updateUserToLocal(UserModel userModel) async {
    return db.update(
      'users',
      userModel.toJson(),
      where: 'id = ?',
      whereArgs: [userModel.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
