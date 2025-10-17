import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/services/session_manager.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/logout.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Logout _logout;
  final SessionManager _sessionManager;

  AuthBloc({required Logout logout, required SessionManager sessionManager})
      : _logout = logout,
        _sessionManager = sessionManager,
        super(const AuthState()) {
    on<AuthStatusRequested>(_onStatusRequested);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onStatusRequested(
    AuthStatusRequested event,
    Emitter<AuthState> emit,
  ) {
    final currentUser = _sessionManager.getCurrentUser();
    if (currentUser != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: currentUser,
        removeError: true,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        removeUser: true,
        removeError: true,
      ));
    }
  }

  FutureOr<void> _onLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, removeError: true));
    await _sessionManager.persistUser(event.user);
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      isLoading: false,
      user: event.user,
      removeError: true,
    ));
  }

  FutureOr<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, removeError: true));
    final result = await _logout(NoParams());
    if (result == null) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error, please try again.',
      ));
      return;
    }

    await result.fold(
      (failure) async {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: mapFailureToMessage(failure),
        ));
      },
      (_) async {
        await _sessionManager.clear();
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          removeUser: true,
          removeError: true,
        ));
      },
    );
  }
}
