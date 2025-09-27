import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_app/features/auth/domain/repositories/auth_repositories.dart';

class AddUser implements UseCase<int, User> {
  final AuthRepository addUserRepository;

  AddUser(this.addUserRepository);

  @override
  Future<Either<Failure, int>?> call(User userModel) async {
    return await addUserRepository.addUser(userModel);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
