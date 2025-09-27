import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class LoginActionState extends LoginState {
  const LoginActionState();
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginActionState {
  const LoginLoadingState();
}

class ReadyToLoginState extends LoginState {
  const ReadyToLoginState();
}

class LoggedState extends LoginActionState {
  const LoggedState();
}

class LoginErrorState extends LoginActionState {
  final String message;

  const LoginErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
