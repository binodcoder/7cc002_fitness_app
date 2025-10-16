import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

@immutable
abstract class RoutineListEvent extends Equatable {
  const RoutineListEvent();

  @override
  List<Object?> get props => const [];
}

class RoutineListInitialEvent extends RoutineListEvent {
  const RoutineListInitialEvent();
}

class RoutineListEditButtonClickedEvent extends RoutineListEvent {
  final Routine routine;
  const RoutineListEditButtonClickedEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}

class RoutineListDeleteButtonClickedEvent extends RoutineListEvent {
  final Routine routine;
  const RoutineListDeleteButtonClickedEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}

class RoutineListDeleteAllButtonClickedEvent extends RoutineListEvent {
  const RoutineListDeleteAllButtonClickedEvent();
}

class RoutineListAddButtonClickedEvent extends RoutineListEvent {
  const RoutineListAddButtonClickedEvent();
}

class RoutineListTileNavigateEvent extends RoutineListEvent {
  final Routine routine;
  const RoutineListTileNavigateEvent({required this.routine});

  @override
  List<Object?> get props => [routine];
}
