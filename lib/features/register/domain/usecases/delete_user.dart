import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/user_repositories.dart';

class DeleteUser implements UseCase<int, int> {
  UserRepository userRepository;

  DeleteUser(this.userRepository);

  @override
  Future<Either<Failure, int>?> call(int userId) async {
    return await userRepository.deleteUser(userId);
  }
}
