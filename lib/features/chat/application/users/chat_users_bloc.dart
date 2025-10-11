import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import '../../domain/usecases/get_chat_users.dart';
import 'chat_users_event.dart';
import 'chat_users_state.dart';

class ChatUsersBloc extends Bloc<ChatUsersEvent, ChatUsersState> {
  ChatUsersBloc(
      {required GetChatUsers getChatUsers,
      required SessionManager sessionManager})
      : _getChatUsers = getChatUsers,
        _session = sessionManager,
        super(const ChatUsersState()) {
    on<ChatUsersRequested>(_onRequested);
  }

  final GetChatUsers _getChatUsers;
  final SessionManager _session;

  Future<void> _onRequested(
      ChatUsersRequested event, Emitter<ChatUsersState> emit) async {
    emit(state.copyWith(loading: true, clearError: true));
    final res = await _getChatUsers(NoParams());
    if (res == null) {
      emit(state.copyWith(loading: false, errorMessage: 'Unexpected error'));
      return;
    }
    final currentId = _session.getCurrentUser()?.id;
    res.fold(
      (failure) => emit(state.copyWith(
          loading: false, errorMessage: mapFailureToMessage(failure))),
      (users) {
        final filtered = users
            .where((u) => u.id != null && u.id != currentId)
            .toList()
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        emit(state.copyWith(loading: false, users: filtered, clearError: true));
      },
    );
  }
}
