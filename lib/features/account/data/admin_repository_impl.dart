import 'package:fitness_app/features/account/data/firebase_data_source.dart';
import 'package:fitness_app/features/account/domain/repository/admin_repository.dart';
import 'package:fitness_app/core/entities/user.dart';

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
