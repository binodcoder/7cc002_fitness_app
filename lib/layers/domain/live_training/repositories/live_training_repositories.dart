import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../core/model/live_training_model.dart';

abstract class LiveTrainingRepository {
  Future<Either<Failure, List<LiveTrainingModel>>>? getLiveTrainings();
  Future<Either<Failure, int>>? addLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<Either<Failure, int>>? updateLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<Either<Failure, int>>? deleteLiveTraining(int liveTrainingId);
}
