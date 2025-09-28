import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/features/auth/domain/usecases/reset_password.dart';

import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPassword _resetPassword;

  ResetPasswordBloc({required ResetPassword resetPassword})
      : _resetPassword = resetPassword,
        super(const ResetPasswordState()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  FutureOr<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading, clearError: true));
    final result = await _resetPassword(event.email);
    if (result == null) {
      emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: 'Unexpected error, please try again.',
      ));
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: mapFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        status: ResetPasswordStatus.success,
        clearError: true,
      )),
    );
  }
}
