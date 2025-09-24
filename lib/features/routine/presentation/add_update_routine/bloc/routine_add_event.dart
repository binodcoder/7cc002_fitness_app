import 'package:fitness_app/features/routine/domain/entities/routine.dart';

abstract class RoutineAddEvent {}

class RoutineAddInitialEvent extends RoutineAddEvent {}

class RoutineAddPickFromGalaryButtonPressEvent extends RoutineAddEvent {}

class RoutineAddPickFromCameraButtonPressEvent extends RoutineAddEvent {}

class RoutineAddSaveButtonPressEvent extends RoutineAddEvent {
  final Routine newRoutine;
  RoutineAddSaveButtonPressEvent(this.newRoutine);
}

class RoutineAddUpdateButtonPressEvent extends RoutineAddEvent {
  final Routine updatedRoutine;
  RoutineAddUpdateButtonPressEvent(this.updatedRoutine);
}

class RoutineAddReadyToUpdateEvent extends RoutineAddEvent {
  final Routine routine;
  RoutineAddReadyToUpdateEvent(this.routine);
}
