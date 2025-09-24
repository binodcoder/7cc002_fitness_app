import 'package:fitness_app/features/login/domain/entities/login.dart';

abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {
  final Login login;
  LoginButtonPressEvent(this.login);
}
