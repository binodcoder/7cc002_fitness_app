import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  final ResetPasswordStatus status;
  final String? errorMessage;

  bool get isLoading => status == ResetPasswordStatus.loading;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

