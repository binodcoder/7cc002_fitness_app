import 'package:fitness_app/core/entities/user.dart' as entity;

abstract class ChatDirectoryRemoteDataSource {
  Future<List<entity.User>> getUsers();
}
