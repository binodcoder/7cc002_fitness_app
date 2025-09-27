import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class DeleteUser implements UseCase<int, int> {
  AuthRepository userRepository;

  DeleteUser(this.userRepository);

  @override
  Future<Either<Failure, int>?> call(int userId) async {
    return await userRepository.deleteUser(userId);
  }
}
