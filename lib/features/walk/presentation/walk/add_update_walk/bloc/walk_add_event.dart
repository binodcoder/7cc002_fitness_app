import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkAddEvent extends Equatable {
  const WalkAddEvent();

  @override
  List<Object?> get props => const [];
}

class WalkAddInitialEvent extends WalkAddEvent {
  const WalkAddInitialEvent();
}

class WalkAddPickFromGalaryButtonPressEvent extends WalkAddEvent {
  const WalkAddPickFromGalaryButtonPressEvent();
}

class WalkAddPickFromCameraButtonPressEvent extends WalkAddEvent {
  const WalkAddPickFromCameraButtonPressEvent();
}

class WalkAddSaveButtonPressEvent extends WalkAddEvent {
  final Walk newWalk;
  const WalkAddSaveButtonPressEvent({required this.newWalk});

  @override
  List<Object?> get props => [newWalk];
}

class WalkAddUpdateButtonPressEvent extends WalkAddEvent {
  final Walk updatedWalk;
  const WalkAddUpdateButtonPressEvent({required this.updatedWalk});

  @override
  List<Object?> get props => [updatedWalk];
}

class WalkAddReadyToUpdateEvent extends WalkAddEvent {
  final Walk walk;
  const WalkAddReadyToUpdateEvent({required this.walk});

  @override
  List<Object?> get props => [walk];
}
