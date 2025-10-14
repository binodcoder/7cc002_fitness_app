import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class SignInWithGoogle implements UseCase<User, NoParams> {
  final GoogleAuthRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>?> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
