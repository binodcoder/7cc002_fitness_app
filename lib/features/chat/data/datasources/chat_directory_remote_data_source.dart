import 'package:fitness_app/features/auth/domain/entities/user.dart' as entity;

abstract class ChatDirectoryRemoteDataSource {
  Future<List<entity.User>> getUsers();
}
