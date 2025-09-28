import 'package:fitness_app/features/routine/data/models/routine_model.dart';

abstract class RoutineDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<int> addRoutine(RoutineModel routineModel);
  Future<int> updateRoutine(RoutineModel routineModel);
  Future<int> deleteRoutine(int routineId);
}
