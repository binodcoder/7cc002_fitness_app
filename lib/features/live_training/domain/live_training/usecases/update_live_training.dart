import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/core/model/live_training_model.dart';
import '../repositories/live_training_repositories.dart';

class UpdateLiveTraining implements UseCase<int, LiveTrainingModel> {
  LiveTrainingRepository liveTrainingRepository;

  UpdateLiveTraining(this.liveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(LiveTrainingModel liveTrainingModel) async {
    return await liveTrainingRepository.updateLiveTraining(liveTrainingModel);
  }
}
