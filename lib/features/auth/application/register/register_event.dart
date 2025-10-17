import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/core/entities/user.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => const [];
}

class UserAddInitialEvent extends RegisterEvent {
  const UserAddInitialEvent();
}

class UserAddPickFromGalaryButtonPressEvent extends RegisterEvent {
  const UserAddPickFromGalaryButtonPressEvent();
}

class UserAddPickFromCameraButtonPressEvent extends RegisterEvent {
  const UserAddPickFromCameraButtonPressEvent();
}

class UserAddSaveButtonPressEvent extends RegisterEvent {
  final User user;
  const UserAddSaveButtonPressEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserAddUpdateButtonPressEvent extends RegisterEvent {
  final User updatedUser;
  const UserAddUpdateButtonPressEvent({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}

class UserAddReadyToUpdateEvent extends RegisterEvent {
  final User user;
  const UserAddReadyToUpdateEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
