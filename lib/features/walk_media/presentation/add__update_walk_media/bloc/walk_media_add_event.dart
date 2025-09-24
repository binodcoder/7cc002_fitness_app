import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';

abstract class WalkMediaAddEvent {}

class WalkMediaAddInitialEvent extends WalkMediaAddEvent {}

class WalkMediaAddPickFromGalaryButtonPressEvent extends WalkMediaAddEvent {}

class WalkMediaAddPickFromCameraButtonPressEvent extends WalkMediaAddEvent {}

class WalkMediaAddSaveButtonPressEvent extends WalkMediaAddEvent {
  final WalkMedia newWalkMedia;
  WalkMediaAddSaveButtonPressEvent(this.newWalkMedia);
}

class WalkMediaAddUpdateButtonPressEvent extends WalkMediaAddEvent {
  final WalkMedia updatedWalkMedia;
  WalkMediaAddUpdateButtonPressEvent(this.updatedWalkMedia);
}

class WalkMediaAddReadyToUpdateEvent extends WalkMediaAddEvent {
  final WalkMedia walkMedia;
  WalkMediaAddReadyToUpdateEvent(this.walkMedia);
}
