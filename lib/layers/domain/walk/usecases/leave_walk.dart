import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/walk_participant_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/walk_repositories.dart';

class LeaveWalk implements UseCase<int, WalkParticipantModel> {
  WalkRepository walkRepository;

  LeaveWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(
      WalkParticipantModel walkParticipantModel) async {
    return await walkRepository.leaveWalk(walkParticipantModel);
  }
}
