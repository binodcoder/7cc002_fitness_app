import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/register/data/models/user_model.dart';
import 'package:fitness_app/features/register/domain/entities/user.dart' as entity;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../domain/repositories/user_repositories.dart';
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
  Future<Either<Failure, int>>? addUser(entity.User userModel) async {
    try {
      final model = userModel is UserModel ? userModel as UserModel : UserModel.fromEntity(userModel);
      int response = await addUserRemoteDataSource.addUser(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateUser(entity.User userModel) async {
    try {
      final model = userModel is UserModel ? userModel as UserModel : UserModel.fromEntity(userModel);
      int response = await addUserRemoteDataSource.updateUser(model);
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
