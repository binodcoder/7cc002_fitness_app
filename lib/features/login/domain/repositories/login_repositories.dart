import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/login/domain/entities/login.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/register/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>>? login(Login loginModel);
}
