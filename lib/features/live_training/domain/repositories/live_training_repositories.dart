import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

abstract class LiveTrainingRepository {
  Future<Either<Failure, List<LiveTraining>>>? getLiveTrainings();
  Future<Either<Failure, int>>? addLiveTraining(LiveTraining liveTraining);
  Future<Either<Failure, int>>? updateLiveTraining(LiveTraining liveTraining);
  Future<Either<Failure, int>>? deleteLiveTraining(int liveTrainingId);
}
