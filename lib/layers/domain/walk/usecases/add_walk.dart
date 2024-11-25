import '../../../../core/errors/failures.dart';
import '../../../../core/model/walk_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class AddWalk implements UseCase<int, WalkModel> {
  final WalkRepository walkRepository;

  AddWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(WalkModel walkModel) async {
    return await walkRepository.addWalk(walkModel);
  }
}
