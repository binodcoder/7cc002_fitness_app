import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

class ChatState extends Equatable {
  final bool loading;
  final List<ChatMessage> messages;
  final String? errorMessage;
  const ChatState(
      {this.loading = false, this.messages = const [], this.errorMessage});

  ChatState copyWith(
      {bool? loading,
      List<ChatMessage>? messages,
      String? errorMessage,
      bool clearError = false}) {
    return ChatState(
      loading: loading ?? this.loading,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [loading, messages, errorMessage];
}
