import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_model.dart';

abstract class WalkRepository {
  Future<Either<Failure, List<WalkModel>>>? getWalks();
  Future<Either<Failure, int>>? addWalk(WalkModel walkModel);
  Future<Either<Failure, int>>? updateWalk(WalkModel walkModel);
}
