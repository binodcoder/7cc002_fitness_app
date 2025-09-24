import 'package:fitness_app/features/routine/domain/entities/routine.dart';

abstract class RoutineEvent {}

class RoutineInitialEvent extends RoutineEvent {}

class RoutineEditButtonClickedEvent extends RoutineEvent {
  final Routine routine;
  RoutineEditButtonClickedEvent(this.routine);
}

class RoutineDeleteButtonClickedEvent extends RoutineEvent {
  final Routine routine;
  RoutineDeleteButtonClickedEvent(this.routine);
}

class RoutineDeleteAllButtonClickedEvent extends RoutineEvent {}

class RoutineAddButtonClickedEvent extends RoutineEvent {}

class RoutineTileNavigateEvent extends RoutineEvent {
  final Routine routine;
  RoutineTileNavigateEvent(this.routine);
}
