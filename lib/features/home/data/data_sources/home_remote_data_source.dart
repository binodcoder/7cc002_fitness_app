import 'package:fitness_app/features/home/data/models/routine_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<int> addRoutine(RoutineModel routineModel);
  Future<int> updateRoutine(RoutineModel routineModel);
  Future<int> deleteRoutine(int routineId);
  Stream<int> getUnreadCount(int userId);
}
