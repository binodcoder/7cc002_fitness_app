import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

@immutable
abstract class RoutineAddEvent extends Equatable {
  const RoutineAddEvent();

  @override
  List<Object?> get props => const [];
}

class RoutineAddInitialEvent extends RoutineAddEvent {
  const RoutineAddInitialEvent();
}

class RoutineAddPickFromGalaryButtonPressEvent extends RoutineAddEvent {
  const RoutineAddPickFromGalaryButtonPressEvent();
}

class RoutineAddPickFromCameraButtonPressEvent extends RoutineAddEvent {
  const RoutineAddPickFromCameraButtonPressEvent();
}

class RoutineAddSaveButtonPressEvent extends RoutineAddEvent {
  final Routine newRoutine;
  const RoutineAddSaveButtonPressEvent({required this.newRoutine});

  @override
  List<Object?> get props => [newRoutine];
}

class RoutineAddUpdateButtonPressEvent extends RoutineAddEvent {
  final Routine updatedRoutine;
  const RoutineAddUpdateButtonPressEvent({required this.updatedRoutine});

  @override
  List<Object?> get props => [updatedRoutine];
}

class RoutineAddReadyToUpdateEvent extends RoutineAddEvent {
  final Routine routine;
  const RoutineAddReadyToUpdateEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}
