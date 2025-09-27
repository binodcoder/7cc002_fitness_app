import 'package:fitness_app/features/walk/data/models/walk_model.dart';

abstract class WalksLocalDataSource {
  Future<List<WalkModel>> getWalks();
}

class WalksLocalDataSourceImpl implements WalksLocalDataSource {
  WalksLocalDataSourceImpl();

  @override
  Future<List<WalkModel>> getWalks() async => [];
}
