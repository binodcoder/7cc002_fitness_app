import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/live_training_repositories.dart';

class DeleteLiveTraining implements UseCase<int, int> {
  LiveTrainingRepository liveTrainingRepository;

  DeleteLiveTraining(this.liveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(int liveTrainingId) async {
    return await liveTrainingRepository.deleteLiveTraining(liveTrainingId);
  }
}
