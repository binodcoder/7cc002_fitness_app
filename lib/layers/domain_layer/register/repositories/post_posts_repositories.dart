import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';

abstract class PostPostsRepository {
  Future<Either<Failure, int>>? postPosts(RoutineModel postModel);
}
