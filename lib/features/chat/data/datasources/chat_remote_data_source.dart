import '../../domain/entities/chat_message.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatMessage>> streamMessages(String roomId);
  Future<int> sendMessage(ChatMessage message);
  Future<void> markRoomRead({required String roomId, required String userId});
}
