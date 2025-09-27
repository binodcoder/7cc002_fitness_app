import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/core/errors/failures.dart';

abstract class WalkMediaRepository {
  Future<Either<Failure, List<WalkMedia>>>? getWalkMedia();
  Future<Either<Failure, List<WalkMedia>>>? getWalkMediaByWalkId(int walkId);
  Future<Either<Failure, int>>? addWalkMedia(WalkMedia walkMedia);
  Future<Either<Failure, int>>? updateWalkMedia(WalkMedia walkMedia);
  Future<Either<Failure, int>>? deleteWalkMedia(int userId);
}
