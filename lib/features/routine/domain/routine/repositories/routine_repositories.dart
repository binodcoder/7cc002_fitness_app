import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/routine_model.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<RoutineModel>>>? getRoutines();
  Future<Either<Failure, int>>? addRoutine(RoutineModel routineModel);
  Future<Either<Failure, int>>? updateRoutine(RoutineModel routineModel);
  Future<Either<Failure, int>>? deleteRoutine(int routineId);
}
