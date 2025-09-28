import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {
  Future<int> addUser(UserModel userModel);
  Future<int> updateUser(UserModel userModel);
  Future<int> deleteUser(int userId);
  Future<UserModel> login(LoginCredentialsModel loginModel);
  Future<int> signOut();
}
