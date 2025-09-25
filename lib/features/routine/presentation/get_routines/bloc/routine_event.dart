import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

@immutable
abstract class RoutineEvent extends Equatable {
  const RoutineEvent();

  @override
  List<Object?> get props => const [];
}

class RoutineInitialEvent extends RoutineEvent {
  const RoutineInitialEvent();
}

class RoutineEditButtonClickedEvent extends RoutineEvent {
  final Routine routine;
  const RoutineEditButtonClickedEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}

class RoutineDeleteButtonClickedEvent extends RoutineEvent {
  final Routine routine;
  const RoutineDeleteButtonClickedEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}

class RoutineDeleteAllButtonClickedEvent extends RoutineEvent {
  const RoutineDeleteAllButtonClickedEvent();
}

class RoutineAddButtonClickedEvent extends RoutineEvent {
  const RoutineAddButtonClickedEvent();
}

class RoutineTileNavigateEvent extends RoutineEvent {
  final Routine routine;
  const RoutineTileNavigateEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}
