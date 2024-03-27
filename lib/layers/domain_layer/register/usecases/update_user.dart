import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/failures.dart';
 import '../../../../core/usecases/usecase.dart';
import '../repositories/update_user_repository.dart';

class UpdateUser implements UseCase<int, UserModel> {
  UpdateUserRepository updateUserRepository;

  UpdateUser(this.updateUserRepository);

  @override
  Future<Either<Failure, int>?> call(UserModel userModel) async {
    return await updateUserRepository.updateUser(userModel);
  }
}
