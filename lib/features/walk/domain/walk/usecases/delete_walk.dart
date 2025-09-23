import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/walk_repositories.dart';

class DeleteWalk implements UseCase<int, int> {
  WalkRepository walkRepository;

  DeleteWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(int walkId) async {
    return await walkRepository.deleteWalk(walkId);
  }
}
