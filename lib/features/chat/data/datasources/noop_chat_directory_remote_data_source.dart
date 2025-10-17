import 'package:fitness_app/core/entities/user.dart' as entity;
import 'chat_directory_remote_data_source.dart';

class NoopChatDirectoryRemoteDataSource
    implements ChatDirectoryRemoteDataSource {
  @override
  Future<List<entity.User>> getUsers() async => const <entity.User>[];
}
