import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/walk_repositories.dart';

class LeaveWalk implements UseCase<int, WalkParticipant> {
  WalkRepository walkRepository;

  LeaveWalk(this.walkRepository);

  @override
  Future<Either<Failure, int>?> call(WalkParticipant walkParticipantModel) async {
    return await walkRepository.leaveWalk(walkParticipantModel);
  }
}
