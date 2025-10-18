import 'package:fitness_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:http/http.dart' as http;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/models/user_model.dart';

class RestAuthDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  RestAuthDataSourceImpl({required this.client});

  Future<UserModel> _login(String url, LoginCredentialsModel loginModel) async {
    final response = await client.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: loginModelToJson(
        loginModel,
      ),
    );
    if (response.statusCode == 200) {
      return userModelFromJson(response.body);
    } else {
      throw LoginException();
    }
  }

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

  Future<int> _deleteUser(String url) async {
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
  Future<int> addUser(UserModel userModel) =>
      _addUser("https://wlv-c4790072fbf0.herokuapp.com/api/v1/users", userModel);

  @override
  Future<int> updateUser(UserModel userModel) => _updateUser(
        "https://wlv-c4790072fbf0.herokuapp.com/api/v1/users/${userModel.id}",
        userModel,
      );

  @override
  Future<int> deleteUser(int userId) =>
      _deleteUser("https://wlv-c4790072fbf0.herokuapp.com/api/v1/users/$userId");

  @override
  Future<UserModel> login(LoginCredentialsModel loginModel) =>
      _login("https://wlv-c4790072fbf0.herokuapp.com/api/v1/users/login", loginModel);

  @override
  Future<UserModel> signInWithGoogle() async {
    throw UnimplementedError('Google Sign-In not supported for REST backend');
  }

  @override
  Future<int> signOut() async {
    // No server session to revoke in this REST stub; treat as success.
    return 1;
  }

  @override
  Future<int> resetPassword(String email) async {
    // No REST endpoint configured; treat as success for now.
    return 1;
  }
}
