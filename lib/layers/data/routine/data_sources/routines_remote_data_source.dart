import 'package:fitness_app/core/model/routine_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
  Future<int> addRoutine(RoutineModel routineModel);
  Future<int> updateRoutine(RoutineModel routineModel);
  Future<int> deleteRoutine(int routineId);
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final http.Client client;

  RoutineRemoteDataSourceImpl({required this.client});

  Future<List<RoutineModel>> _getRoutines(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return routineModelsFromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  Future<int> _addRoutine(String url, RoutineModel routineModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: routineModelToJson(routineModel),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateRoutine(String url, RoutineModel routineModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: routineModelToJson(routineModel),
    );
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _deleteRoutine(String url) async {
    final response = await client.delete(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<RoutineModel>> getRoutines() => _getRoutines("https://wlv-c4790072fbf0.herokuapp.com/api/v1/routines");

  @override
  Future<int> addRoutine(RoutineModel routineModel) => _addRoutine("https://wlv-c4790072fbf0.herokuapp.com/api/v1/routines", routineModel);

  @override
  Future<int> deleteRoutine(int routineId) => _deleteRoutine("https://wlv-c4790072fbf0.herokuapp.com/api/v1/routines/$routineId");

  @override
  Future<int> updateRoutine(RoutineModel routineModel) =>
      _updateRoutine("https://wlv-c4790072fbf0.herokuapp.com/api/v1/routines/${routineModel.id}", routineModel);
}
