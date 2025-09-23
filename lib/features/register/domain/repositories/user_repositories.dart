import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/register/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, int>>? addUser(User userModel);
  Future<Either<Failure, int>>? updateUser(User userModel);
  Future<Either<Failure, int>>? deleteUser(int userId);
}
