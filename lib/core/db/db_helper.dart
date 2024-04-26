import 'dart:async';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/live_training_model.dart';
import '../model/routine_model.dart';
import '../model/walk_media_model.dart';

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

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE routine (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            difficulty TEXT,
            duration INTEGER,
            source TEXT,
          )
        ''');
    });
  }

  Future<int> insertRoutine(RoutineModel routineModel) async {
    final db = await database;
    return await db!.insert('routine', routineModel.toJson());
  }

  Future<List<RoutineModel>> getRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');

    return List.generate(maps.length, (i) {
      return RoutineModel(
        id: maps[i]['id'],
        description: maps[i]['description'],
        source: maps[i]['source'],
        name: maps[i]['name'],
        difficulty: maps[i]['difficulty'],
        duration: maps[i]['duration'],
      );
    });
  }

  Future<List<LiveTrainingModel>> getLiveTraining() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');
    return List.generate(maps.length, (i) {
      return LiveTrainingModel(
        trainerId: 0,
        title: '',
        description: '',
        trainingDate: DateTime.now(),
        startTime: '',
        endTime: '',
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
        participants: [],
      );
    });
  }

  Future<List<WalkMediaModel>> getWalkMedia() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');
    return List.generate(maps.length, (i) {
      return WalkMediaModel(
        id: 1,
        walkId: 0,
        userId: 0,
        mediaUrl: '',
      );
    });
  }

  Future<List<WalkMediaModel>> getWalkMediaByWalkId(walkId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('routine');
    return List.generate(maps.length, (i) {
      return WalkMediaModel(
        id: 1,
        walkId: 0,
        userId: 0,
        mediaUrl: '',
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

  insertUser(UserModel userModel) {}
}
