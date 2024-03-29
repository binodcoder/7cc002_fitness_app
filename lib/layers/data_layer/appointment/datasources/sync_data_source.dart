import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
 import '../../../../core/model/sync_data_model.dart';
import '../../../../core/model/user_model.dart';

abstract class SyncRemoteDataSource {
  Future<SyncModel> sync();
}

class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  final http.Client client;

  SyncRemoteDataSourceImpl({required this.client});

  Future<SyncModel> _sync(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return syncModelFromJson(response.body);
      //   return RoutineModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SyncModel> sync() =>
      _sync("https://wlv-c4790072fbf0.herokuapp.com/api/v1/sync");
}
