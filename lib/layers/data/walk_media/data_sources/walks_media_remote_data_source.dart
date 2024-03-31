import 'dart:io';

import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/walk_media_model.dart';

abstract class WalkMediaRemoteDataSource {
  Future<List<WalkMediaModel>> getWalkMedias();
  Future<int> addWalkMedia(WalkMediaModel walkMediaModel);
  Future<int> updateWalkMedia(WalkMediaModel walkMediaModel);
  Future<int> deleteWalkMedia(int userId);
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId);
}

class WalkMediaRemoteDataSourceImpl implements WalkMediaRemoteDataSource {
  final http.Client client;

  WalkMediaRemoteDataSourceImpl({required this.client});

  Future<List<WalkMediaModel>> _getWalkMedias(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return walkMediaModelsFromJson(response.body);
      //   return WalkMediaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<WalkMediaModel>> _getWalkMediaByWalkId(String url) async {
    final response = await client.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return walkMediaModelsFromJson(response.body);
      //   return WalkMediaModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      List<WalkMediaModel> notFound = [];
      return notFound;
    } else {
      throw ServerException();
    }
  }

  Future<int> _addWalkMedia(String url, WalkMediaModel walkMediaModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: walkMediaModelToJson(walkMediaModel),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateWalkMedia(String url, WalkMediaModel walkMediaModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: walkMediaModelToJson(walkMediaModel),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _deleteWalkMedia(String url) async {
    final response = await client.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<WalkMediaModel>> getWalkMedias() => _getWalkMedias("https://wlv-c4790072fbf0.herokuapp.com/api/v1/walk-media");

  @override
  Future<int> addWalkMedia(WalkMediaModel walkMediaModel) => _addWalkMedia(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/walk-media",
        walkMediaModel,
      );

  @override
  Future<int> updateWalkMedia(WalkMediaModel walkMediaModel) => _updateWalkMedia(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/WalkMedias/${walkMediaModel.id}",
        walkMediaModel,
      );

  @override
  Future<int> deleteWalkMedia(int userId) => _deleteWalkMedia("https://wlv-c4790072fbf0.herokuapp.com/api/v1/walk-media/$userId");

  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) =>
      _getWalkMediaByWalkId("https://wlv-c4790072fbf0.herokuapp.com/api/v1/walk-media/walk-id/$walkId");
}
