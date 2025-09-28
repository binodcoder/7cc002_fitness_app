import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:fitness_app/features/auth/data/models/login_credentials_model.dart';
import 'package:fitness_app/features/auth/data/models/user_model.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fitness_app/features/auth/data/datasources/auth_local_data_sources.dart';

class AuthRepositoriesImpl implements AuthRepository {
  final AuthLocalDataSources authLocalDataSources;
  final AuthDataSource authRemoteDataSource;
  AuthRepositoriesImpl({
    required this.authLocalDataSources,
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, User>>? login(
      LoginCredentials loginCredentials) async {
    try {
      final model = LoginCredentialsModel.fromEntity(loginCredentials);
      UserModel response = await authRemoteDataSource.login(model);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on LoginException {
      return Left(LoginFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? addUser(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      int response = await authRemoteDataSource.addUser(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? updateUser(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      int response = await authRemoteDataSource.updateUser(model);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? deleteUser(int userId) async {
    try {
      int response = await authRemoteDataSource.deleteUser(userId);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? logout() async {
    try {
      final res = await authRemoteDataSource.signOut();
      return Right(res);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>>? resetPassword(String email) async {
    try {
      final res = await authRemoteDataSource.resetPassword(email);
      return Right(res);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
