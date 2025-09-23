import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/live_training_model.dart';

abstract class LiveTrainingRepository {
  Future<Either<Failure, List<LiveTrainingModel>>>? getLiveTrainings();
  Future<Either<Failure, int>>? addLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<Either<Failure, int>>? updateLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<Either<Failure, int>>? deleteLiveTraining(int liveTrainingId);
}
