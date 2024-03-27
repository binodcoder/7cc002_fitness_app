import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/login_model.dart';
import '../../../../core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../repositories/login_repositories.dart';

class Login implements UseCase<int, LoginModel> {
  final LoginRepository loginRepository;

  Login(this.loginRepository);

  @override
  Future<Either<Failure, int>?> call(LoginModel loginModel) async {
    return await loginRepository.login(loginModel);
  }
}
