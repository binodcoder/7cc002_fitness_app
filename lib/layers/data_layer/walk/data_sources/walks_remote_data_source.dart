import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/walk_model.dart';

abstract class WalkRemoteDataSource {
  Future<List<WalkModel>> getWalks();
  Future<int> addWalk(WalkModel walkModel);
  Future<int> updateWalk(WalkModel walkModel);
}

class WalkRemoteDataSourceImpl implements WalkRemoteDataSource {
  final http.Client client;

  WalkRemoteDataSourceImpl({required this.client});

  Future<List<WalkModel>> _getWalks(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return walkModelFromJson(response.body);
      //   return WalkModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<int> _addWalk(String url, WalkModel walkModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: walkModel.toJson(),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateWalk(String url, WalkModel walkModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: walkModel.toJson(),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WalkModel>> getWalks() =>
      _getWalks("https://wlv-c4790072fbf0.herokuapp.com/api/v1/walks");

  @override
  Future<int> addWalk(WalkModel walkModel) => _addWalk(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/walks",
        walkModel,
      );

  @override
  Future<int> updateWalk(WalkModel walkModel) => _updateWalk(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/walks/${walkModel.id}",
        walkModel,
      );
}
