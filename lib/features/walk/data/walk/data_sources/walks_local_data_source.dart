import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/model/walk_model.dart';

abstract class WalksLocalDataSource {
  Future<List<WalkModel>> getWalks();
}

class WalksLocalDataSourceImpl implements WalksLocalDataSource {
  final DatabaseHelper dbHelper = DatabaseHelper();
  WalksLocalDataSourceImpl();

  @override
  Future<List<WalkModel>> getWalks() => _getWalksFromLocal();

  Future<List<WalkModel>> _getWalksFromLocal() async {
   List<WalkModel> walkModelList = await dbHelper.getWalks();
   return walkModelList;
  }
}
