import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/core/errors/exceptions.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_remote_data_source.dart';

class FirebaseChatRemoteDataSource implements ChatRemoteDataSource {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  @override
  Stream<List<ChatMessage>> streamMessages(String roomId) {
    final ref = _firestore
        .collection('chatRooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true);
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((d) {
        final data = d.data();
        return ChatMessage(
          id: d.id,
          roomId: roomId,
          authorId: (data['authorId'] as String?) ?? '',
          text: (data['text'] as String?) ?? '',
          createdAt: DateTime.fromMillisecondsSinceEpoch(
              (data['createdAt'] as num?)?.toInt() ?? 0,
              isUtc: true),
        );
      }).toList();
    });
  }

  @override
  Future<int> sendMessage(ChatMessage message) async {
    try {
      final ref = _firestore
          .collection('chatRooms')
          .doc(message.roomId)
          .collection('messages')
          .doc();
      await ref.set({
        'authorId': message.authorId,
        'text': message.text,
        'createdAt': message.createdAt.millisecondsSinceEpoch,
      });
      // Upsert room metadata for listing/unread indicators
      final roomRef = _firestore.collection('chatRooms').doc(message.roomId);
      // Try to extract both user ids from room id pattern: dm_<low>_<high>
      int? otherUserId;
      int? authorIdInt;
      try {
        final parts = message.roomId.split('_');
        if (parts.length == 3) {
          final low = int.tryParse(parts[1]);
          final high = int.tryParse(parts[2]);
          authorIdInt = int.tryParse(message.authorId);
          if (low != null && high != null && authorIdInt != null) {
            otherUserId = (authorIdInt == low) ? high : low;
          }
        }
      } catch (_) {}

      final data = <String, dynamic>{
        'lastMessageText': message.text,
        'lastMessageAt': message.createdAt.millisecondsSinceEpoch,
        'lastMessageAuthorId': message.authorId,
      };
      if (otherUserId != null) {
        data['unreadFor'] = FieldValue.arrayUnion([otherUserId]);
      }
      await roomRef.set(data, SetOptions(merge: true));
      return 1;
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> markRoomRead(
      {required String roomId, required String userId}) async {
    final roomRef = _firestore.collection('chatRooms').doc(roomId);
    final uid = int.tryParse(userId);
    await roomRef.set({
      'lastReadAt_$userId': DateTime.now().toUtc().millisecondsSinceEpoch,
      if (uid != null) 'unreadFor': FieldValue.arrayRemove([uid]),
    }, SetOptions(merge: true));
  }
}
