import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

abstract class WalkRepository {
  Future<Either<Failure, List<Walk>>>? getWalks();
  Future<Either<Failure, int>>? addWalk(Walk walk);
  Future<Either<Failure, int>>? updateWalk(Walk walk);
  Future<Either<Failure, int>>? deleteWalk(int userId);
  Future<Either<Failure, int>>? joinWalk(WalkParticipant walkParticipant);
  Future<Either<Failure, int>>? leaveWalk(WalkParticipant walkParticipant);
}
