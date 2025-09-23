import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/model/walk_media_model.dart';

abstract class WalkMediaLocalDataSource {
  Future<List<WalkMediaModel>> getWalkMedias();
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId);
}

class WalkMediaLocalDataSourceImpl implements WalkMediaLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  WalkMediaLocalDataSourceImpl();

  @override
  Future<List<WalkMediaModel>> getWalkMedias() => _getWalkMediasFromLocal();

  Future<List<WalkMediaModel>> _getWalkMediasFromLocal() async {
    List<WalkMediaModel> walkMediaModelList = await dbHelper.getWalkMedia();
    return walkMediaModelList;
  }

  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async {
    List<WalkMediaModel> walkMediaModelList = await dbHelper.getWalkMediaByWalkId(walkId);
    return walkMediaModelList;
  }
}
