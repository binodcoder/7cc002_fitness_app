import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => const [];
}

class ChatStarted extends ChatEvent {
  final String roomId;
  const ChatStarted(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class ChatSendPressed extends ChatEvent {
  final String roomId;
  final String authorId;
  final String text;
  const ChatSendPressed(
      {required this.roomId, required this.authorId, required this.text});
  @override
  List<Object?> get props => [roomId, authorId, text];
}
