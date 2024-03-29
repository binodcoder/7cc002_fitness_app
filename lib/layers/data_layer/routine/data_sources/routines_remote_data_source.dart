import 'package:fitness_app/core/model/routine_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getRoutines();
}

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final http.Client client;

  RoutineRemoteDataSourceImpl({required this.client});

  Future<List<RoutineModel>> _getRoutines(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return routineModelsFromJson(response.body);
      //   return RoutineModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<RoutineModel>> getRoutines() => _getRoutines("https://wlv-c4790072fbf0.herokuapp.com/api/v1/routines");
}
