import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';

abstract class LiveTrainingLocalDataSource {
  Future<List<LiveTrainingModel>> getLiveTrainings();
}

class LiveTrainingLocalDataSourceImpl implements LiveTrainingLocalDataSource {
  LiveTrainingLocalDataSourceImpl();

  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() async => [];
}
