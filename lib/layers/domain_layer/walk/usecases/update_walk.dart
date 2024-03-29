import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_model.dart';
import '../../../../core/usecases/usecase.dart';
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
