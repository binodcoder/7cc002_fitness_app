import '../../../../../core/model/walk_model.dart';

abstract class WalkEvent {}

class WalkInitialEvent extends WalkEvent {}

class WalkEditButtonClickedEvent extends WalkEvent {}

class WalkDeleteButtonClickedEvent extends WalkEvent {
  final WalkModel walkModel;
  WalkDeleteButtonClickedEvent(this.walkModel);
}

class WalkDeleteAllButtonClickedEvent extends WalkEvent {}

class WalkAddButtonClickedEvent extends WalkEvent {}

class WalkTileNavigateEvent extends WalkEvent {
  final WalkModel walkModel;
  WalkTileNavigateEvent(this.walkModel);
}
