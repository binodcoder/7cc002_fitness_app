import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/db/db_helper.dart';

abstract class UpdateUserLocalDataSources {
  Future<int> updateUser(UserModel userModel);
}

class UpdateUserLocalDataSourcesImpl implements UpdateUserLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  UpdateUserLocalDataSourcesImpl();
  @override
  Future<int> updateUser(UserModel userModel) => _updateUserToLocal(userModel);

  Future<int> _updateUserToLocal(UserModel userModel) async {
    final int response = await databaseHelper.updatePost(userModel);
    return response;
  }
}
