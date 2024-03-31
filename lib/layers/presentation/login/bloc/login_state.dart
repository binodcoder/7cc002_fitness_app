abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitialState extends LoginState {}

class ReadyToLoginState extends LoginState {}

class LoggedState extends LoginActionState {}

class LoginErrorState extends LoginActionState {}
