import 'package:fitness_app/features/admin/data/firebase_data_source.dart';
import 'package:fitness_app/features/admin/domain/repository/admin_repository.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

class AdminRepositoryImpl extends AdminRepository {
  AdminRepositoryImpl({required this.firebaseDataSource});
  final FirebaseDataSource firebaseDataSource;

  @override
  Stream<List<User>> getUsers() {
    return firebaseDataSource.getUsers();
  }

  @override
  Future<void> updateUser(int userId, String role) {
    return firebaseDataSource.updateUser(userId, role);
  }
}
