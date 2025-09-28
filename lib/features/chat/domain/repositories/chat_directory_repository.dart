import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

abstract class ChatDirectoryRepository {
  Future<Either<Failure, List<User>>?> getUsers();
}
