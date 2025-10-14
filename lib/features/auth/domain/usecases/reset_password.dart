import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class ResetPassword implements UseCase<int, String> {
  final AuthRepository repository;
  ResetPassword(this.repository);

  @override
  Future<Either<Failure, int>?> call(String email) async {
    return await repository.resetPassword(email);
  }
}
