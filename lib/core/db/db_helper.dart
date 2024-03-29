import 'dart:async';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/routine_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'fitness.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE routine (
            id INTEGER PRIMARY KEY,
            coachId INTEGER,
            description TEXT,
            source TEXT
          )
        ''');
    });
  }

  Future<int> insertUser(UserModel post) async {
    final db = await database;
    return await db!.insert('routine', post.toJson());
  }

  Future<List<RoutineModel>> getRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');
    return List.generate(maps.length, (i) {
      return RoutineModel(
        id: maps[i]['id'],
        description: maps[i]['description'],
        source: maps[i]['source'],
        name: '',
        difficulty: '',
        duration: 0,
      );
    });
  }

  Future<List<WalkModel>> getWalks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');
    return List.generate(maps.length, (i) {
      return WalkModel(
        id: 1,
        proposerId: 1,
        routeData: '',
        date: DateTime.now(),
        startTime: '',
        startLocation: '',
      );
    });
  }

  Future<int> updatePost(UserModel post) async {
    final db = await database;
    return await db!.update(
      'routine',
      post.toJson(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  Future<int> deletePost(int postId) async {
    final db = await database;
    return await db!.delete('routine', where: 'id = ?', whereArgs: [postId]);
  }
}
