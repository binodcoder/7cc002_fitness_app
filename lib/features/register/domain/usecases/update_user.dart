import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/register/domain/entities/user.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/user_repositories.dart';

class UpdateUser implements UseCase<int, User> {
  UserRepository userRepository;

  UpdateUser(this.userRepository);

  @override
  Future<Either<Failure, int>?> call(User userModel) async {
    return await userRepository.updateUser(userModel);
  }
}
