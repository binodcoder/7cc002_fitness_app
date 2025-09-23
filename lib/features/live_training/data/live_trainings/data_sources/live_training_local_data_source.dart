import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/model/live_training_model.dart';

abstract class LiveTrainingLocalDataSource {
  Future<List<LiveTrainingModel>> getLiveTrainings();
}

class LiveTrainingLocalDataSourceImpl implements LiveTrainingLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  LiveTrainingLocalDataSourceImpl();

  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() => _getLiveTrainingFromLocal();

  Future<List<LiveTrainingModel>> _getLiveTrainingFromLocal() async {
    List<LiveTrainingModel> liveTrainingModelList = await dbHelper.getLiveTraining();
    return liveTrainingModelList;
  }
}
