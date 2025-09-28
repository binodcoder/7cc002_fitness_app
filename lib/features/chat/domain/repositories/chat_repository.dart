import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failures.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ChatMessage>>> streamMessages(String roomId);
  Future<Either<Failure, int>> sendMessage(ChatMessage message);
  Future<Either<Failure, int>> markRoomRead({required String roomId, required String userId});
}
