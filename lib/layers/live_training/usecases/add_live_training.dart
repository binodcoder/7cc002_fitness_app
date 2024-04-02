import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../core/model/live_training_model.dart';
import '../repositories/live_training_repositories.dart';

class AddLiveTraining implements UseCase<int, LiveTrainingModel> {
  final LiveTrainingRepository addLiveTrainingRepository;

  AddLiveTraining(this.addLiveTrainingRepository);

  @override
  Future<Either<Failure, int>?> call(LiveTrainingModel liveTrainingModel) async {
    return await addLiveTrainingRepository.addLiveTraining(liveTrainingModel);
  }
}
