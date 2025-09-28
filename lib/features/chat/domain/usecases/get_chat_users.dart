import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import '../repositories/chat_directory_repository.dart';

class GetChatUsers implements UseCase<List<User>, NoParams> {
  final ChatDirectoryRepository repository;
  GetChatUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>?> call(NoParams params) async {
    return repository.getUsers();
  }
}
