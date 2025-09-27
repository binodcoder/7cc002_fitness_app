import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_media_repositories.dart';

class AddWalkMedia implements UseCase<int, WalkMedia> {
  final WalkMediaRepository walkMediaRepository;

  AddWalkMedia(this.walkMediaRepository);

  @override
  Future<Either<Failure, int>?> call(WalkMedia walkMedia) async {
    return await walkMediaRepository.addWalkMedia(walkMedia);
  }
}
