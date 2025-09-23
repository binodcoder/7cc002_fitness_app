import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../../domain/register/repositories/user_repositories.dart';
import '../datasources/user_local_data_sources.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoriesImpl implements UserRepository {
  final UserLocalDataSources addUserLocalDataSources;
  final UserRemoteDataSource addUserRemoteDataSource;
  UserRepositoriesImpl({
    required this.addUserLocalDataSources,
    required this.addUserRemoteDataSource,
  });

  @override
  Future<Either<Failure, int>>? addUser(UserModel userModel) async {
    try {
      int response = await addUserRemoteDataSource.addUser(userModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateUser(UserModel userModel) async {
    try {
      int response = await addUserRemoteDataSource.updateUser(userModel);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteUser(int userId) async {
    try {
      int response = await addUserRemoteDataSource.deleteUser(userId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
