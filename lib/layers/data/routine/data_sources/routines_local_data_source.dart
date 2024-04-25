import '../../../../core/db/db_helper.dart';
import '../../../../core/model/routine_model.dart';

abstract class RoutinesLocalDataSource {
  Future<List<RoutineModel>> getLastRoutines();
  Future<void>? cacheRoutine(RoutineModel routineModel);
}

class RoutinesLocalDataSourceImpl implements RoutinesLocalDataSource {
  final DatabaseHelper dbHelper;
  RoutinesLocalDataSourceImpl(this.dbHelper);

  @override
  Future<List<RoutineModel>> getLastRoutines() => _getRoutinesFromLocal();

  Future<List<RoutineModel>> _getRoutinesFromLocal() async {
    List<RoutineModel> routineModelList = await dbHelper.getRoutines();
    return routineModelList;
  }

  @override
  Future<void>? cacheRoutine(RoutineModel routineModel) {
    return dbHelper.insertRoutine(routineModel);
  }
}
