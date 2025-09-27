import 'package:fitness_app/features/walk/data/models/walk_media_model.dart';

abstract class WalkMediaLocalDataSource {
  Future<List<WalkMediaModel>> getWalkMedias();
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId);
}

class WalkMediaLocalDataSourceImpl implements WalkMediaLocalDataSource {
  WalkMediaLocalDataSourceImpl();

  @override
  Future<List<WalkMediaModel>> getWalkMedias() async => [];

  @override
  Future<List<WalkMediaModel>> getWalkMediaByWalkId(int walkId) async => [];
}

