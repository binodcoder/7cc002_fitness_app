import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class JoinWalk implements UseCase<int, WalkParticipant> {
  final WalkRepository walkRepository;

  JoinWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(WalkParticipant walkParticipant) async {
    return await walkRepository.joinWalk(walkParticipant);
  }
}
