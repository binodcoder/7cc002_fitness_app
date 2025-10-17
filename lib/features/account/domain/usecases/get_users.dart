import 'package:fitness_app/features/account/domain/repository/admin_repository.dart';
import 'package:fitness_app/core/entities/user.dart';

class GetUsers {
  GetUsers(this.adminRepository);

  AdminRepository adminRepository;
  Stream<List<User>> call() {
    return adminRepository.getUsers();
  }
}
