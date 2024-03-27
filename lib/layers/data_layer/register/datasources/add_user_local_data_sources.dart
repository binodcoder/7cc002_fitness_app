import '../../../../../core/db/db_helper.dart';
 import '../../../../core/model/user_model.dart';

abstract class AddUserLocalDataSources {
  Future<int> addUser(UserModel userModel);
}

class AddUserLocalDataSourcesImpl extends AddUserLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  AddUserLocalDataSourcesImpl();
  @override
  Future<int> addUser(UserModel userModel) => _postPostsToLocal(userModel);

  Future<int> _postPostsToLocal(UserModel userModel) async {
    int response = await databaseHelper.insertUser(userModel);
    return response;
  }
}
