import 'package:fitness_app/features/walk_media/data/models/walk_media_model.dart';

abstract class WalkMediaEvent {}

class WalkMediaInitialEvent extends WalkMediaEvent {
  int walkId;
  WalkMediaInitialEvent(this.walkId);
}

class WalkMediaEditButtonClickedEvent extends WalkMediaEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaEditButtonClickedEvent(this.walkMediaModel);
}

class WalkMediaDeleteButtonClickedEvent extends WalkMediaEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaDeleteButtonClickedEvent(this.walkMediaModel);
}

class WalkMediaDeleteAllButtonClickedEvent extends WalkMediaEvent {}

class WalkMediaAddButtonClickedEvent extends WalkMediaEvent {
  final int walkId;
  WalkMediaAddButtonClickedEvent(this.walkId);
}

class WalkMediaTileNavigateEvent extends WalkMediaEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaTileNavigateEvent(this.walkMediaModel);
}
