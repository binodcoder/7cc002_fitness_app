import 'package:fitness_app/features/walk/data/models/walk_model.dart';

abstract class WalkAddEvent {}

class WalkAddInitialEvent extends WalkAddEvent {}

class WalkAddPickFromGalaryButtonPressEvent extends WalkAddEvent {}

class WalkAddPickFromCameraButtonPressEvent extends WalkAddEvent {}

class WalkAddSaveButtonPressEvent extends WalkAddEvent {
  final WalkModel newWalk;
  WalkAddSaveButtonPressEvent(this.newWalk);
}

class WalkAddUpdateButtonPressEvent extends WalkAddEvent {
  final WalkModel updatedWalk;
  WalkAddUpdateButtonPressEvent(this.updatedWalk);
}

class WalkAddReadyToUpdateEvent extends WalkAddEvent {
  final WalkModel walkModel;
  WalkAddReadyToUpdateEvent(this.walkModel);
}
