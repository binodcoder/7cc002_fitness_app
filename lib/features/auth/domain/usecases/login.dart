import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/core/entities/user.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class Login implements UseCase<User, LoginCredentials> {
  final AuthRepository userRepository;

  Login(this.userRepository);

  @override
  Future<Either<Failure, User>?> call(LoginCredentials loginCredentials) async {
    return await userRepository.login(loginCredentials);
  }
}
