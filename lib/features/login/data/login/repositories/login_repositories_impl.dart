import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/model/login_model.dart';
import 'package:fitness_app/core/model/user_model.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../../domain/login/repositories/login_repositories.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl({
    required this.loginRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserModel>>? login(LoginModel loginModel) async {
    try {
      UserModel response = await loginRemoteDataSource.login(loginModel);
      return Right(response);
    } on CacheException {
      return Left(CacheFailure());
    } on LoginException {
      return Left(LoginFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
