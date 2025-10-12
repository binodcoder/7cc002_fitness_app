import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/auth/domain/entities/login_credentials.dart';
import 'package:fitness_app/core/usecases/usecase.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => const [];
}

class LoginInitialEvent extends LoginEvent {
  const LoginInitialEvent();
}

class LoginButtonPressEvent extends LoginEvent {
  final LoginCredentials login;
  const LoginButtonPressEvent({required this.login});

  @override
  List<Object?> get props => [login];
}

class GoogleSignInPressed extends LoginEvent {
  const GoogleSignInPressed();

  @override
  List<Object?> get props => [NoParams()];
}
