import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class RoutinesLocalDataSource {
  Future<List<RoutineModel>> getLastRoutines();
  Future<void> cacheRoutine(RoutineModel routineModel);
  Future<void> cacheRoutines(List<RoutineModel> routines);
  Future<void> clearRoutines();
}

class RoutinesLocalDataSourceImpl implements RoutinesLocalDataSource {
  final Database db;
  RoutinesLocalDataSourceImpl(this.db);

  @override
  Future<List<RoutineModel>> getLastRoutines() => _getRoutinesFromLocal();

  Future<List<RoutineModel>> _getRoutinesFromLocal() async {
    final maps = await db.query('routine');
    return List.generate(maps.length, (i) {
      final m = maps[i];
      return RoutineModel(
        id: m['id'] as int?,
        name: m['name'] as String,
        description: m['description'] as String,
        difficulty: m['difficulty'] as String,
        duration: (m['duration'] as num).toInt(),
        source: m['source'] as String,
      );
    });
  }

  @override
  Future<void> cacheRoutine(RoutineModel routineModel) async {
    await db.insert(
      'routine',
      {
        'id': routineModel.id,
        'name': routineModel.name,
        'description': routineModel.description,
        'difficulty': routineModel.difficulty,
        'duration': routineModel.duration,
        'source': routineModel.source,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> cacheRoutines(List<RoutineModel> routines) async {
    final batch = db.batch();
    for (final r in routines) {
      batch.insert(
        'routine',
        {
          'id': r.id,
          'name': r.name,
          'description': r.description,
          'difficulty': r.difficulty,
          'duration': r.duration,
          'source': r.source,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> clearRoutines() async {
    await db.delete('routine');
  }
}
