import 'package:fitness_app/features/routine/data/models/routine_model.dart';

abstract class RoutineEvent {}

class RoutineInitialEvent extends RoutineEvent {}

class RoutineEditButtonClickedEvent extends RoutineEvent {
  final RoutineModel routineModel;
  RoutineEditButtonClickedEvent(this.routineModel);
}

class RoutineDeleteButtonClickedEvent extends RoutineEvent {
  final RoutineModel routineModel;
  RoutineDeleteButtonClickedEvent(this.routineModel);
}

class RoutineDeleteAllButtonClickedEvent extends RoutineEvent {}

class RoutineAddButtonClickedEvent extends RoutineEvent {}

class RoutineTileNavigateEvent extends RoutineEvent {
  final RoutineModel routineModel;
  RoutineTileNavigateEvent(this.routineModel);
}
