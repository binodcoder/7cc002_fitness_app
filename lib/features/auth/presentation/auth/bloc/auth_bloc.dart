import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/logout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Logout logout;

  AuthBloc({required this.logout})
      : super(const AuthInitialState()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingActionState());
    final result = await logout(NoParams());
    result!.fold((failure) {
      emit(AuthErrorActionState(mapFailureToMessage(failure)));
    }, (_) async {
      emit(const AuthLoggedOutActionState());
    });
  }
}
