import '../../../../core/db/db_helper.dart';
import '../../../../core/model/routine_model.dart';

abstract class UpdatePostLocalDataSources {
  Future<int> updatePost(RoutineModel postModel);
}

class UpdatePostLocalDataSourcesImpl implements UpdatePostLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  UpdatePostLocalDataSourcesImpl();
  @override
  Future<int> updatePost(RoutineModel postModel) => _updatePostToLocal(postModel);

  Future<int> _updatePostToLocal(RoutineModel postModel) async {
    final int response = await databaseHelper.updatePost(postModel);
    return response;
  }
}
