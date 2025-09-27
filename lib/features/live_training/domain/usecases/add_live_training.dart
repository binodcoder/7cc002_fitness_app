import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import '../repositories/live_training_repositories.dart';

class AddLiveTraining implements UseCase<int, LiveTraining> {
  final LiveTrainingRepository addLiveTrainingRepository;

  AddLiveTraining(this.addLiveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(LiveTraining liveTraining) async {
    return await addLiveTrainingRepository.addLiveTraining(liveTraining);
  }
}
