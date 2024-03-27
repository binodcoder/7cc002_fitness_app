import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/failures.dart';

abstract class UpdateUserRepository {
  Future<Either<Failure, int>>? updateUser(UserModel userModel);
}
