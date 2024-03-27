import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/user_model.dart';
import '../../../domain_layer/register/repositories/update_user_repository.dart';
import '../datasources/update_user_local_data_sources.dart';

class UpdateUserRepositoriesImpl implements UpdateUserRepository {
  UpdateUserLocalDataSources updateUserLocalDataSources;
  UpdateUserRepositoriesImpl({required this.updateUserLocalDataSources});

  @override
  Future<Either<Failure, int>>? updateUser(UserModel userModel) async {
    try {
      int response = await updateUserLocalDataSources.updateUser(userModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
