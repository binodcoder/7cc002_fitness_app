import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/user_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/model/routine_model.dart';
import '../../../domain_layer/register/repositories/add_user_repositories.dart';
import '../datasources/add_user_local_data_sources.dart';
import '../datasources/add_user_remote_data_source.dart';

class AddUserRepositoriesImpl implements AddUserRepository {
  final AddUserLocalDataSources addUserLocalDataSources;
  final AddUserRemoteDataSource addUserRemoteDataSource;
  AddUserRepositoriesImpl({required this.addUserLocalDataSources, required this.addUserRemoteDataSource,});

  @override
  Future<Either<Failure, int>>? addUser(UserModel userModel) async {
    try {
      int response = await addUserRemoteDataSource.addUser(userModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
