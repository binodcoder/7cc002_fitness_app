import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/walk_media_repositories.dart';

class DeleteWalkMedia implements UseCase<int, int> {
  WalkMediaRepository walkMediaRepository;

  DeleteWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, int>?> call(int walkMediaId) async {
    return await walkMediaRepository.deleteWalkMedia(walkMediaId);
  }
}
