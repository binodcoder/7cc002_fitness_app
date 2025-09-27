import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Minimal tables to support current local caching
        await db.execute('''
          CREATE TABLE routine (
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            difficulty TEXT,
            duration INTEGER,
            source TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            age INTEGER,
            email TEXT,
            gender TEXT,
            institutionEmail TEXT,
            name TEXT,
            password TEXT,
            role TEXT
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = _db;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _db = null;
  }
}
