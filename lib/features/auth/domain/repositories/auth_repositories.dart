import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, int>>? addUser(User user);
  Future<Either<Failure, int>>? updateUser(User user);
  Future<Either<Failure, int>>? deleteUser(int userId);
  Future<Either<Failure, User>>? login(LoginCredentials login);
  Future<Either<Failure, int>>? logout();
  Future<Either<Failure, int>>? resetPassword(String email);
}

abstract class GoogleAuthRepository {
  Future<Either<Failure, User>>? signInWithGoogle();
}
