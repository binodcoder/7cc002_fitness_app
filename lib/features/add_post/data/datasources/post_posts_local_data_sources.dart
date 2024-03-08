import '../../../../core/db/db_helper.dart';
import '../../../../core/model/routine_model.dart';

abstract class PostPostsLocalDataSources {
  Future<int> postPosts(RoutineModel postModel);
}

class PostPostsLocalDataSourcesImpl extends PostPostsLocalDataSources {
  DatabaseHelper databaseHelper = DatabaseHelper();

  PostPostsLocalDataSourcesImpl();
  @override
  Future<int> postPosts(RoutineModel postModel) => _postPostsToLocal(postModel);

  Future<int> _postPostsToLocal(RoutineModel postModel) async {
    int response = await databaseHelper.insertPost(postModel);
    return response;
  }
}
