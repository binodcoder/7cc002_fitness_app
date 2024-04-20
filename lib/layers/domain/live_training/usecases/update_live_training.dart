import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../core/model/live_training_model.dart';
import '../repositories/live_training_repositories.dart';

class UpdateLiveTraining implements UseCase<int, LiveTrainingModel> {
  LiveTrainingRepository liveTrainingRepository;

  UpdateLiveTraining(this.liveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(LiveTrainingModel liveTrainingModel) async {
    return await liveTrainingRepository.updateLiveTraining(liveTrainingModel);
  }
}
