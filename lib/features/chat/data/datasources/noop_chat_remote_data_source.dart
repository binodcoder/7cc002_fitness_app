import '../../domain/entities/chat_message.dart';
import 'chat_remote_data_source.dart';

class NoopChatRemoteDataSource implements ChatRemoteDataSource {
  @override
  Future<int> sendMessage(ChatMessage message) async => 1;

  @override
  Stream<List<ChatMessage>> streamMessages(String roomId) async* {
    yield const <ChatMessage>[];
  }

  @override
  Future<void> markRoomRead(
      {required String roomId, required String userId}) async {}
}
