import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/update_post_repository.dart';

class UpdatePost implements UseCase<int, RoutineModel> {
  UpdatePostRepository updatePostRepository;

  UpdatePost(this.updatePostRepository);

  @override
  Future<Either<Failure, int>?> call(RoutineModel postModel) async {
    return await updatePostRepository.updatePost(postModel);
  }
}
