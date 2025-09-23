import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/walk_participant_model.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/walk_repositories.dart';

class JoinWalk implements UseCase<int, WalkParticipantModel> {
  final WalkRepository walkRepository;

  JoinWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(WalkParticipantModel walkParticipantModel) async {
    return await walkRepository.joinWalk(walkParticipantModel);
  }
}
