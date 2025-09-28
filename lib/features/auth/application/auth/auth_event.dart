import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

class AuthStatusRequested extends AuthEvent {
  const AuthStatusRequested();
}

class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
