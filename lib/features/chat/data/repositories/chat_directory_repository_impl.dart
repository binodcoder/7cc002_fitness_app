import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import 'package:fitness_app/core/entities/user.dart';
import '../../domain/repositories/chat_directory_repository.dart';
import '../datasources/chat_directory_remote_data_source.dart';

class ChatDirectoryRepositoryImpl implements ChatDirectoryRepository {
  final ChatDirectoryRemoteDataSource remote;
  ChatDirectoryRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<User>>?> getUsers() async {
    try {
      final users = await remote.getUsers();
      return Right(users);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
