import 'package:fitness_app/features/login/data/models/login_model.dart';

abstract class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {
  final LoginModel loginModel;
  LoginButtonPressEvent(this.loginModel);
}
