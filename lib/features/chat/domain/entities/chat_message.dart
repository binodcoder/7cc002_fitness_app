import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String roomId;
  final String authorId;
  final String text;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.authorId,
    required this.text,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, roomId, authorId, text, createdAt];
}
