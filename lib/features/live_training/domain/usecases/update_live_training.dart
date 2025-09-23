import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import '../repositories/live_training_repositories.dart';

class UpdateLiveTraining implements UseCase<int, LiveTraining> {
  LiveTrainingRepository liveTrainingRepository;

  UpdateLiveTraining(this.liveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(LiveTraining liveTrainingModel) async {
    return await liveTrainingRepository.updateLiveTraining(liveTrainingModel);
  }
}
