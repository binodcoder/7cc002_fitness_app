import 'package:fitness_app/features/register/domain/entities/user.dart' as user_entity;
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/login/domain/entities/login.dart' as login_entity;
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/login_repositories.dart';

class Login implements UseCase<user_entity.User, login_entity.Login> {
  final LoginRepository loginRepository;

  Login(this.loginRepository);

  @override
  Future<Either<Failure, user_entity.User>?> call(login_entity.Login loginModel) async {
    return await loginRepository.login(loginModel);
  }
}
