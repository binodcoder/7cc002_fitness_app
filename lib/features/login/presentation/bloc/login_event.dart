import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/login/domain/entities/login.dart';

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
  final Login login;
  const LoginButtonPressEvent({required this.login});

  @override
  List<Object?> get props => [login];
}
