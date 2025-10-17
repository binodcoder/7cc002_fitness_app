import 'package:fitness_app/features/account/domain/repository/admin_repository.dart';

class UpdateUser {
  UpdateUser(this.adminRepository);

  AdminRepository adminRepository;

  Future<void> call(int userId, String role) {
    return adminRepository.updateUser(userId, role);
  }
}
