import 'package:sqflite/sqflite.dart';
import 'package:fitness_app/features/profile/data/models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel?> getCurrent(String id);
  Future<int> upsert(UserProfileModel model);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Database db;
  ProfileLocalDataSourceImpl({required this.db});

  @override
  Future<UserProfileModel?> getCurrent(String id) async {
    final rows = await db.query(
      'user_profiles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserProfileModel.fromJson(rows.first);
  }

  @override
  Future<int> upsert(UserProfileModel model) async {
    return db.insert(
      'user_profiles',
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

