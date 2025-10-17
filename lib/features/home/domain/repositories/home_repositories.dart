import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Routine>>>? getRoutines();
  Future<Either<Failure, int>>? addRoutine(Routine routine);
  Future<Either<Failure, int>>? updateRoutine(Routine routine);
  Future<Either<Failure, int>>? deleteRoutine(int routineId);
  Stream<int> getUnreadCount(int userId);
}
