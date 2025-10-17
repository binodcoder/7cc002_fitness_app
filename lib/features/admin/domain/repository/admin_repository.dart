import 'package:fitness_app/features/auth/domain/entities/user.dart';

abstract class AdminRepository {
  Stream<List<User>> getUsers();
  Future<void> updateUser(int userId, String role);
}
