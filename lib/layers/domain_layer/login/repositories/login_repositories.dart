import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/login_model.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, int>>? login(LoginModel loginModel);
}
