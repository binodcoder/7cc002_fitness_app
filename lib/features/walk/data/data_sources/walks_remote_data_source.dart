import 'package:fitness_app/features/walk/data/models/walk_model.dart';
import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';
export 'walks_remote_rest_data_source.dart' show WalkRemoteDataSourceImpl;

abstract class WalkRemoteDataSource {
  Future<List<WalkModel>> getWalks();
  Future<int> addWalk(WalkModel walkModel);
  Future<int> updateWalk(WalkModel walkModel);
  Future<int> deleteWalk(int userId);
  Future<int> joinWalk(WalkParticipantModel walkParticipantModel);
  Future<int> leaveWalk(WalkParticipantModel walkParticipantModel);
}
