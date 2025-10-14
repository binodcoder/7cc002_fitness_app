import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class Logout implements UseCase<int, NoParams> {
  final AuthRepository repository;
  Logout(this.repository);

  @override
  Future<Either<Failure, int>?> call(NoParams params) async {
    return await repository.logout();
  }
}
