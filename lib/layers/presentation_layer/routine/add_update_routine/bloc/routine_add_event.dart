
import '../../../../../core/model/routine_model.dart';

abstract class RoutineAddEvent {}

class RoutineAddInitialEvent extends RoutineAddEvent {}

class RoutineAddPickFromGalaryButtonPressEvent extends RoutineAddEvent {}

class RoutineAddPickFromCameraButtonPressEvent extends RoutineAddEvent {}

class RoutineAddSaveButtonPressEvent extends RoutineAddEvent {
  final RoutineModel newRoutine;
  RoutineAddSaveButtonPressEvent(this.newRoutine);
}

class RoutineAddUpdateButtonPressEvent extends RoutineAddEvent {
  final RoutineModel updatedRoutine;
  RoutineAddUpdateButtonPressEvent(this.updatedRoutine);
}

class RoutineAddReadyToUpdateEvent extends RoutineAddEvent {
  final RoutineModel routineModel;
  RoutineAddReadyToUpdateEvent(this.routineModel);
}
