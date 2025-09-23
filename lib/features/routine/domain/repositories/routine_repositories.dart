import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<Routine>>>? getRoutines();
  Future<Either<Failure, int>>? addRoutine(Routine routineModel);
  Future<Either<Failure, int>>? updateRoutine(Routine routineModel);
  Future<Either<Failure, int>>? deleteRoutine(int routineId);
}
