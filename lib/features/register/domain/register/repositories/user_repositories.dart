import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/model/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, int>>? addUser(UserModel userModel);
  Future<Either<Failure, int>>? updateUser(UserModel userModel);
  Future<Either<Failure, int>>? deleteUser(int userId);
}
