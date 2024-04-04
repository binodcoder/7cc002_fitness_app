import 'package:fitness_app/core/model/login_model.dart';

abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {
  final LoginModel loginModel;
  LoginButtonPressEvent(this.loginModel);
}
