import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/walk_media_repositories.dart';

class GetWalkMediaByWalkId implements UseCase<List<WalkMedia>, int> {
  final WalkMediaRepository walkMediaRepository;

  GetWalkMediaByWalkId(this.walkMediaRepository);

  @override
  Future<Either<Failure, List<WalkMedia>>?> call(int walkId) async {
    return await walkMediaRepository.getWalkMediaByWalkId(walkId);
  }
}
