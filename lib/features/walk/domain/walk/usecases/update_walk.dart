import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/walk_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class UpdateWalk implements UseCase<int, WalkModel> {
  final WalkRepository updateWalkRepository;

  UpdateWalk(this.updateWalkRepository);

  @override
  Future<Either<Failure, int>?> call(WalkModel walkModel) async {
    return await updateWalkRepository.updateWalk(walkModel);
  }
}
