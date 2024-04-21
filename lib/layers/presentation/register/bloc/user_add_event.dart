import '../../../../core/model/user_model.dart';

abstract class UserAddEvent {}

class UserAddInitialEvent extends UserAddEvent {}

class UserAddPickFromGalaryButtonPressEvent extends UserAddEvent {}

class UserAddPickFromCameraButtonPressEvent extends UserAddEvent {}

class UserAddSaveButtonPressEvent extends UserAddEvent {
  final UserModel newUser;
  UserAddSaveButtonPressEvent(this.newUser);
}

class UserAddUpdateButtonPressEvent extends UserAddEvent {
  final UserModel updatedUser;
  UserAddUpdateButtonPressEvent(this.updatedUser);
}

class UserAddReadyToUpdateEvent extends UserAddEvent {
  final UserModel userModel;
  UserAddReadyToUpdateEvent(this.userModel);
}
