import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl({required this.remote});

  @override
  Stream<Either<Failure, List<ChatMessage>>> streamMessages(String roomId) {
    return remote
        .streamMessages(roomId)
        .map<Either<Failure, List<ChatMessage>>>(
          (messages) => Right(messages),
        );
  }

  @override
  Future<Either<Failure, int>> sendMessage(ChatMessage message) async {
    try {
      final res = await remote.sendMessage(message);
      return Right(res);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> markRoomRead(
      {required String roomId, required String userId}) async {
    try {
      await remote.markRoomRead(roomId: roomId, userId: userId);
      return const Right(1);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
