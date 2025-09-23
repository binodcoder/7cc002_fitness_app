import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';

abstract class WalkMediaRepository {
  Future<Either<Failure, List<WalkMedia>>>? getWalkMedia();
  Future<Either<Failure, List<WalkMedia>>>? getWalkMediaByWalkId(int walkId);
  Future<Either<Failure, int>>? addWalkMedia(WalkMedia walkMediaModel);
  Future<Either<Failure, int>>? updateWalkMedia(WalkMedia walkMediaModel);
  Future<Either<Failure, int>>? deleteWalkMedia(int userId);
}
