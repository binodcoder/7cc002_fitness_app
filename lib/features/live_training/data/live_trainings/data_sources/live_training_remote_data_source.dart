import 'package:http/http.dart' as http;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/model/live_training_model.dart';

abstract class LiveTrainingRemoteDataSource {
  Future<List<LiveTrainingModel>> getLiveTrainings();
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel);
  Future<int> deleteLiveTraining(int liveTrainingId);
}

class LiveTrainingRemoteDataSourceImpl implements LiveTrainingRemoteDataSource {
  final http.Client client;

  LiveTrainingRemoteDataSourceImpl({required this.client});

  Future<List<LiveTrainingModel>> _getLiveTrainings(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return liveTrainingModelsFromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  Future<int> _addLiveTraining(String url, LiveTrainingModel liveTrainingModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: liveTrainingModelToJson(liveTrainingModel),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateLiveTraining(String url, LiveTrainingModel liveTrainingModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: liveTrainingModelToJson(liveTrainingModel),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _deleteLiveTraining(String url) async {
    final response = await client.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<LiveTrainingModel>> getLiveTrainings() => _getLiveTrainings("https://wlv-c4790072fbf0.herokuapp.com/api/v1/live-trainings");

  @override
  Future<int> addLiveTraining(LiveTrainingModel liveTrainingModel) =>
      _addLiveTraining("https://wlv-c4790072fbf0.herokuapp.com/api/v1/live-trainings", liveTrainingModel);

  @override
  Future<int> deleteLiveTraining(int liveTrainingId) =>
      _deleteLiveTraining("https://wlv-c4790072fbf0.herokuapp.com/api/v1/live-trainings/$liveTrainingId");

  @override
  Future<int> updateLiveTraining(LiveTrainingModel liveTrainingModel) =>
      _updateLiveTraining("https://wlv-c4790072fbf0.herokuapp.com/api/v1/live-trainings/${liveTrainingModel.trainerId}", liveTrainingModel);
}
