import 'package:fitness_app/core/model/walk_media_model.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/walk_media_repositories.dart';

class GetWalkMediaByWalkId implements UseCase<List<WalkMediaModel>, int> {
  final WalkMediaRepository walkMediaRepository;

  GetWalkMediaByWalkId(this.walkMediaRepository);

  @override
  Future<Either<Failure, List<WalkMediaModel>>?> call(int walkId) async {
    return await walkMediaRepository.getWalkMediaByWalkId(walkId);
  }
}
