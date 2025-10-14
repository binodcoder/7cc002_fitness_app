import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_media_repositories.dart';

class GetWalkMedia implements UseCase<List<WalkMedia>, NoParams> {
  final WalkMediaRepository walkMediaRepository;

  GetWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, List<WalkMedia>>?> call(NoParams params) async {
    return await walkMediaRepository.getWalkMedia();
  }
}
