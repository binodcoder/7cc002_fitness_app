import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/features/auth/domain/usecases/login.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login _login;

  LoginBloc({required Login login})
      : _login = login,
        super(const LoginState()) {
    on<LoginInitialEvent>(_onInitial);
    on<LoginButtonPressEvent>(_onLoginRequested);
  }

  void _onInitial(LoginInitialEvent event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }

  FutureOr<void> _onLoginRequested(
    LoginButtonPressEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      status: LoginStatus.loading,
      clearError: true,
      clearUser: true,
    ));

    final result = await _login(event.login);
    if (result == null) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Unexpected error, please try again.',
        clearUser: true,
      ));
      return;
    }

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: mapFailureToMessage(failure),
        clearUser: true,
      )),
      (user) => emit(state.copyWith(
        status: LoginStatus.success,
        user: user,
        clearError: true,
      )),
    );
  }
}
