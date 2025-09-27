import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class AuthActionState extends AuthState {
  const AuthActionState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingActionState extends AuthActionState {
  const AuthLoadingActionState();
}

class AuthLoggedOutActionState extends AuthActionState {
  const AuthLoggedOutActionState();
}

class AuthErrorActionState extends AuthActionState {
  final String message;
  const AuthErrorActionState(this.message);

  @override
  List<Object?> get props => [message];
}

