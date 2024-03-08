import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/post_posts_repositories.dart';

class PostPosts implements UseCase<int, RoutineModel> {
  final PostPostsRepository postRepository;

  PostPosts(this.postRepository);

  @override
  Future<Either<Failure, int>?> call(RoutineModel postModel) async {
    return await postRepository.postPosts(postModel);
  }
}
