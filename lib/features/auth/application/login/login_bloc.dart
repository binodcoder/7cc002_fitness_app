import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/auth/domain/usecases/login.dart';
import 'package:fitness_app/features/auth/domain/usecases/sign_in_with_google.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login _login;
  final SignInWithGoogle _signInWithGoogle;

  LoginBloc({required Login login, required SignInWithGoogle signInWithGoogle})
      : _login = login,
        _signInWithGoogle = signInWithGoogle,
        super(const LoginState()) {
    on<LoginInitialEvent>(_onInitial);
    on<LoginButtonPressEvent>(_onLoginRequested);
    on<GoogleSignInPressed>(_onGoogleSignInRequested);
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

  FutureOr<void> _onGoogleSignInRequested(
    GoogleSignInPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(
      status: LoginStatus.loading,
      clearError: true,
      clearUser: true,
    ));

    final result = await _signInWithGoogle(NoParams());
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
