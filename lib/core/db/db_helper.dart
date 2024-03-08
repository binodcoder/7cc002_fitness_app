import 'dart:async';
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
    final path = join(databasesPath, 'blog.db');

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE posts (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            imagePath TEXT,
            isSelected integer
          )
        ''');
    });
  }

  Future<int> insertPost(RoutineModel post) async {
    final db = await database;
    return await db!.insert('posts', post.toMap());
  }

  Future<List<RoutineModel>> getRoutines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('posts');
    return List.generate(maps.length, (i) {
      return RoutineModel(
        maps[i]['id'],
        maps[i]['title'],
        maps[i]['content'],
        maps[i]['imagePath'],
        maps[i]['isSelected'],
      );
    });
  }

  Future<int> updatePost(RoutineModel post) async {
    final db = await database;
    return await db!.update(
      'posts',
      post.toMap(),
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  Future<int> deletePost(String postId) async {
    final db = await database;
    return await db!.delete('posts', where: 'id = ?', whereArgs: [postId]);
  }
}
