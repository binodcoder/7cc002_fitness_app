import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../domain_layer/register/repositories/update_post_repository.dart';
import '../datasources/update_posts_local_data_sources.dart';


class UpdatePostRepositoriesImpl implements UpdatePostRepository {
  UpdatePostLocalDataSources updatePostLocalDataSources;
  UpdatePostRepositoriesImpl({required this.updatePostLocalDataSources});

  @override
  Future<Either<Failure, int>>? updatePost(RoutineModel postModel) async {
    try {
      int response = await updatePostLocalDataSources.updatePost(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
