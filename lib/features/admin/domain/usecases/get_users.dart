import 'package:fitness_app/features/admin/domain/repository/admin_repository.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

class GetUsers {
  GetUsers(this.adminRepository);

  AdminRepository adminRepository;
  Stream<List<User>> call() {
    return adminRepository.getUsers();
  }
}
