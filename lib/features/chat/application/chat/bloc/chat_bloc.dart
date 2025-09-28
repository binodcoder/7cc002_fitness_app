import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import '../../../domain/entities/chat_message.dart';
import '../../../domain/usecases/send_message.dart';
import '../../../domain/usecases/stream_messages.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
      {required StreamMessages streamMessages,
      required SendMessage sendMessage})
      : _streamMessages = streamMessages,
        _sendMessage = sendMessage,
        super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<ChatSendPressed>(_onSend);
  }

  final StreamMessages _streamMessages;
  final SendMessage _sendMessage;
  StreamSubscription? _subscription;

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    await _subscription?.cancel();
    emit(state.copyWith(loading: true, clearError: true));
    final res = await _streamMessages(event.roomId);
    if (res == null) {
      emit(state.copyWith(loading: false, errorMessage: 'Unexpected error'));
      return;
    }
    await res.fold(
      (failure) async {
        emit(state.copyWith(
          loading: false,
          errorMessage: mapFailureToMessage(failure),
        ));
      },
      (stream) async {
        // Use emit.forEach to safely emit from a stream within a handler
        await emit.forEach(stream, onData: (either) {
          return either.fold(
            (failure) => state.copyWith(
              loading: false,
              errorMessage: mapFailureToMessage(failure),
            ),
            (messages) => state.copyWith(
              loading: false,
              messages: messages,
              clearError: true,
            ),
          );
        }, onError: (_, __) {
          return state.copyWith(
            loading: false,
            errorMessage: 'Failed to load chat messages.',
          );
        });
      },
    );
  }

  Future<void> _onSend(ChatSendPressed event, Emitter<ChatState> emit) async {
    final message = ChatMessage(
      id: 'local',
      roomId: event.roomId,
      authorId: event.authorId,
      text: event.text,
      createdAt: DateTime.now().toUtc(),
    );
    final res = await _sendMessage(message);
    if (res == null) return;
    res.fold(
      (_) => null,
      (_) => null,
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
