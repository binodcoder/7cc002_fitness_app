import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class AddWalk implements UseCase<int, Walk> {
  final WalkRepository walkRepository;

  AddWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(Walk walk) async {
    return await walkRepository.addWalk(walk);
  }
}
