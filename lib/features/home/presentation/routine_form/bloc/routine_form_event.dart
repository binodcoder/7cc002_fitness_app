import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';

@immutable
abstract class RoutineFormEvent extends Equatable {
  const RoutineFormEvent();

  @override
  List<Object?> get props => const [];
}

class RoutineFormInitialEvent extends RoutineFormEvent {
  const RoutineFormInitialEvent();
}

class RoutineFormPickFromGalleryButtonPressEvent extends RoutineFormEvent {
  const RoutineFormPickFromGalleryButtonPressEvent();
}

class RoutineFormPickFromCameraButtonPressEvent extends RoutineFormEvent {
  const RoutineFormPickFromCameraButtonPressEvent();
}

class RoutineFormSaveButtonPressEvent extends RoutineFormEvent {
  final Routine newRoutine;
  const RoutineFormSaveButtonPressEvent({required this.newRoutine});

  @override
  List<Object?> get props => [newRoutine];
}

class RoutineFormUpdateButtonPressEvent extends RoutineFormEvent {
  final Routine updatedRoutine;
  const RoutineFormUpdateButtonPressEvent({required this.updatedRoutine});

  @override
  List<Object?> get props => [updatedRoutine];
}

class RoutineFormReadyToUpdateEvent extends RoutineFormEvent {
  final Routine routine;
  const RoutineFormReadyToUpdateEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}
