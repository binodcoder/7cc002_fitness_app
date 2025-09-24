import 'package:fitness_app/features/walk/domain/entities/walk.dart';

abstract class WalkAddEvent {}

class WalkAddInitialEvent extends WalkAddEvent {}

class WalkAddPickFromGalaryButtonPressEvent extends WalkAddEvent {}

class WalkAddPickFromCameraButtonPressEvent extends WalkAddEvent {}

class WalkAddSaveButtonPressEvent extends WalkAddEvent {
  final Walk newWalk;
  WalkAddSaveButtonPressEvent(this.newWalk);
}

class WalkAddUpdateButtonPressEvent extends WalkAddEvent {
  final Walk updatedWalk;
  WalkAddUpdateButtonPressEvent(this.updatedWalk);
}

class WalkAddReadyToUpdateEvent extends WalkAddEvent {
  final Walk walk;
  WalkAddReadyToUpdateEvent(this.walk);
}
