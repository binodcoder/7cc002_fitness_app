import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/entities/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    User? user,
    bool removeUser = false,
    String? errorMessage,
    bool removeError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      user: removeUser ? null : (user ?? this.user),
      errorMessage: removeError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, isLoading, user, errorMessage];
}
