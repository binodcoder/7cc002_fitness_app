import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';

abstract class LiveTrainingDataSource {
  Future<List<LiveTrainingModel>> getLiveTrainings();
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<int> deleteLiveTraining(int liveTrainingId);
}
