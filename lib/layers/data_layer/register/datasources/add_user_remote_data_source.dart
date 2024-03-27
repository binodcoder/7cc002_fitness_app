import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/model/user_model.dart';

abstract class AddUserRemoteDataSource {
  Future<int> addUser(UserModel userModel);
}

class AddUserRemoteDataSourceImpl implements AddUserRemoteDataSource {
  final http.Client client;

  AddUserRemoteDataSourceImpl({required this.client});

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

  @override
  Future<int> addUser(UserModel userModel) => _addUser(
      "https://wlv-c4790072fbf0.herokuapp.com/api/v1/users", userModel);
}
