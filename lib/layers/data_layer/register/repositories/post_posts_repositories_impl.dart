import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../domain_layer/register/repositories/post_posts_repositories.dart';
import '../datasources/post_posts_local_data_sources.dart';

class PostPostsRepositoriesImpl implements PostPostsRepository {
  final PostPostsLocalDataSources postPostsLocalDataSources;
  PostPostsRepositoriesImpl({required this.postPostsLocalDataSources});

  @override
  Future<Either<Failure, int>>? postPosts(RoutineModel postModel) async {
    try {
      int response = await postPostsLocalDataSources.postPosts(postModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
