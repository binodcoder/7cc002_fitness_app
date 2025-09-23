import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_media_repositories.dart';

class UpdateWalkMedia implements UseCase<int, WalkMedia> {
  final WalkMediaRepository updateWalkMediaRepository;

  UpdateWalkMedia(this.updateWalkMediaRepository);

  @override
  Future<Either<Failure, int>?> call(WalkMedia walkMediaModel) async {
    return await updateWalkMediaRepository.updateWalkMedia(walkMediaModel);
  }
}
