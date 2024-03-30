import '../../../../core/db/db_helper.dart';
import '../../../../core/model/walk_media_model.dart';

abstract class WalkMediasLocalDataSource {
  Future<List<WalkMediaModel>> getWalkMedias();
}

class WalkMediasLocalDataSourceImpl implements WalkMediasLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  WalkMediasLocalDataSourceImpl();

  @override
 Future<List<WalkMediaModel>> getWalkMedias() => _getWalkMediasFromLocal();

 Future<List<WalkMediaModel>> _getWalkMediasFromLocal() async {
    List<WalkMediaModel> walkMediaModelList = await dbHelper.getWalkMedia();
    return walkMediaModelList;

  }
}
