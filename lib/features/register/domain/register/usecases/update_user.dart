import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../repositories/user_repositories.dart';

class UpdateUser implements UseCase<int, UserModel> {
  UserRepository userRepository;

  UpdateUser(this.userRepository);

  @override
  Future<Either<Failure, int>?> call(UserModel userModel) async {
    return await userRepository.updateUser(userModel);
  }
}
