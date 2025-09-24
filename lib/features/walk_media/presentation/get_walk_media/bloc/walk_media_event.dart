import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';

abstract class WalkMediaEvent {}

class WalkMediaInitialEvent extends WalkMediaEvent {
  int walkId;
  WalkMediaInitialEvent(this.walkId);
}

class WalkMediaEditButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  WalkMediaEditButtonClickedEvent(this.walkMedia);
}

class WalkMediaDeleteButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  WalkMediaDeleteButtonClickedEvent(this.walkMedia);
}

class WalkMediaDeleteAllButtonClickedEvent extends WalkMediaEvent {}

class WalkMediaAddButtonClickedEvent extends WalkMediaEvent {
  final int walkId;
  WalkMediaAddButtonClickedEvent(this.walkId);
}

class WalkMediaTileNavigateEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  WalkMediaTileNavigateEvent(this.walkMedia);
}
