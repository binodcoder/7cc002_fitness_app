import '../../../../core/model/walk_media_model.dart';

abstract class WalkMediaAddEvent {}

class WalkMediaAddInitialEvent extends WalkMediaAddEvent {}

class WalkMediaAddPickFromGalaryButtonPressEvent extends WalkMediaAddEvent {}

class WalkMediaAddPickFromCameraButtonPressEvent extends WalkMediaAddEvent {}

class WalkMediaAddSaveButtonPressEvent extends WalkMediaAddEvent {
  final WalkMediaModel newWalkMedia;
  WalkMediaAddSaveButtonPressEvent(this.newWalkMedia);
}

class WalkMediaAddUpdateButtonPressEvent extends WalkMediaAddEvent {
  final WalkMediaModel updatedWalkMedia;
  WalkMediaAddUpdateButtonPressEvent(this.updatedWalkMedia);
}

class WalkMediaAddReadyToUpdateEvent extends WalkMediaAddEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaAddReadyToUpdateEvent(this.walkMediaModel);
}
