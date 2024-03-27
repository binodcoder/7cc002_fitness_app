import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';

abstract class AddUserRepository {
  Future<Either<Failure, int>>? addUser(UserModel userModel);
}
