import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/login_model.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/user_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserModel>>? login(LoginModel loginModel);
}
