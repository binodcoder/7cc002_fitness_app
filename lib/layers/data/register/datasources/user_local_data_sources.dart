import '../../../../../core/db/db_helper.dart';
import '../../../../core/model/user_model.dart';

abstract class UserLocalDataSources {
  Future<int> addUser(UserModel userModel);
  Future<int> updateUser(UserModel userModel);
}

class UserLocalDataSourcesImpl extends UserLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  UserLocalDataSourcesImpl();
  @override
  Future<int> addUser(UserModel userModel) => _postUserToLocal(userModel);

  Future<int> _postUserToLocal(UserModel userModel) async {
    int response = await databaseHelper.insertUser(userModel);
    return response;
  }

  @override
  Future<int> updateUser(UserModel userModel) => _updateUserToLocal(userModel);

  Future<int> _updateUserToLocal(UserModel userModel) async {
    final int response = await databaseHelper.updatePost(userModel);
    return response;
  }
}
