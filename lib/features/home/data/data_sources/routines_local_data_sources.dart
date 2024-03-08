import '../../../../core/db/db_helper.dart';
import '../../../../core/model/routine_model.dart';

abstract class RoutinesLocalDataSource {
  Future<List<RoutineModel>> getRoutines();
}

class RoutinesLocalDataSourceImpl implements RoutinesLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  RoutinesLocalDataSourceImpl();

  @override
  Future<List<RoutineModel>> getRoutines() => _getRoutinesFromLocal();

  Future<List<RoutineModel>> _getRoutinesFromLocal() async {
    List<RoutineModel> routineModelList = await dbHelper.getRoutines();
    return routineModelList;
  }
}
