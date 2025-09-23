import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/login/data/models/login_model.dart';
import 'package:fitness_app/features/register/data/models/user_model.dart';
import 'package:fitness_app/features/login/domain/entities/login.dart' as login_entity;
import 'package:fitness_app/features/register/domain/entities/user.dart' as user_entity;
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../domain/repositories/login_repositories.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl({
    required this.loginRemoteDataSource,
  });

  @override
  Future<Either<Failure, user_entity.User>>? login(login_entity.Login loginModel) async {
    try {
      final model = LoginModel.fromEntity(loginModel);
      UserModel response = await loginRemoteDataSource.login(model);
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
