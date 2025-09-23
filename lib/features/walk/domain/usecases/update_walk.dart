import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class UpdateWalk implements UseCase<int, Walk> {
  final WalkRepository updateWalkRepository;

  UpdateWalk(this.updateWalkRepository);

  @override
  Future<Either<Failure, int>?> call(Walk walkModel) async {
    return await updateWalkRepository.updateWalk(walkModel);
  }
}
