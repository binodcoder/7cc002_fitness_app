import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';

@immutable
abstract class UserAddEvent extends Equatable {
  const UserAddEvent();

  @override
  List<Object?> get props => const [];
}

class UserAddInitialEvent extends UserAddEvent {
  const UserAddInitialEvent();
}

class UserAddPickFromGalaryButtonPressEvent extends UserAddEvent {
  const UserAddPickFromGalaryButtonPressEvent();
}

class UserAddPickFromCameraButtonPressEvent extends UserAddEvent {
  const UserAddPickFromCameraButtonPressEvent();
}

class UserAddSaveButtonPressEvent extends UserAddEvent {
  final User user;
  const UserAddSaveButtonPressEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserAddUpdateButtonPressEvent extends UserAddEvent {
  final User updatedUser;
  const UserAddUpdateButtonPressEvent({required this.updatedUser});

  @override
  List<Object?> get props => [updatedUser];
}

class UserAddReadyToUpdateEvent extends UserAddEvent {
  final User user;
  const UserAddReadyToUpdateEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
