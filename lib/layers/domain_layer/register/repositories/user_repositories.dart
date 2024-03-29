import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, int>>? addUser(UserModel userModel);
  Future<Either<Failure, int>>? updateUser(UserModel userModel);
  Future<Either<Failure, int>>? deleteUser(int userId);
}
