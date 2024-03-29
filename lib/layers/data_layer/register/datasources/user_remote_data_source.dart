import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<int> addUser(UserModel userModel);
  Future<int> updateUser(UserModel userModel);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  Future<int> _addUser(String url, UserModel userModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: userModelToJson(
        userModel,
      ),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  Future<int> _updateUser(String url, UserModel userModel) async {
    final response = await client.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: userModelToJson(
        userModel,
      ),
    );
    if (response.statusCode == 201) {
      return 1;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<int> addUser(UserModel userModel) => _addUser(
      "https://wlv-c4790072fbf0.herokuapp.com/api/v1/users", userModel);

  @override
  Future<int> updateUser(UserModel userModel) => _updateUser(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/users/${userModel.id}",
        userModel,
      );
}
