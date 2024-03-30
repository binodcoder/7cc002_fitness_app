import '../../../../../core/model/walk_media_model.dart';

abstract class WalkMediaEvent {}

class WalkMediaInitialEvent extends WalkMediaEvent {}

class WalkMediaEditButtonClickedEvent extends WalkMediaEvent {}

class WalkMediaDeleteButtonClickedEvent extends WalkMediaEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaDeleteButtonClickedEvent(this.walkMediaModel);
}

class WalkMediaDeleteAllButtonClickedEvent extends WalkMediaEvent {}

class WalkMediaAddButtonClickedEvent extends WalkMediaEvent {}

class WalkMediaTileNavigateEvent extends WalkMediaEvent {
  final WalkMediaModel walkMediaModel;
  WalkMediaTileNavigateEvent(this.walkMediaModel);
}
