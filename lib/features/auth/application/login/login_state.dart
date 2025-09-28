import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  final LoginStatus status;
  final User? user;
  final String? errorMessage;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    LoginStatus? status,
    User? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
