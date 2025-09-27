import 'package:http/http.dart' as http;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';

abstract class SyncRemoteDataSource {
  Future<SyncModel> sync(String email);
}

class SyncRemoteDataSourceImpl implements SyncRemoteDataSource {
  final http.Client client;

  SyncRemoteDataSourceImpl({required this.client});

  Future<SyncModel> _sync(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      // Parse into model which extends the domain entity
      return syncModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SyncModel> sync(String email) =>
      _sync("https://wlv-c4790072fbf0.herokuapp.com/api/v1/sync/email/$email");
}
