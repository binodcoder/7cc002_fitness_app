import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/walk_media_model.dart';

abstract class WalkMediaRepository {
  Future<Either<Failure, List<WalkMediaModel>>>? getWalkMedia();
  Future<Either<Failure, List<WalkMediaModel>>>? getWalkMediaByWalkId(int walkId);
  Future<Either<Failure, int>>? addWalkMedia(WalkMediaModel walkMediaModel);
  Future<Either<Failure, int>>? updateWalkMedia(WalkMediaModel walkMediaModel);
  Future<Either<Failure, int>>? deleteWalkMedia(int userId);
}
