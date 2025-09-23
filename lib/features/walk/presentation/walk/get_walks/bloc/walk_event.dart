import 'package:fitness_app/features/walk/data/models/walk_participant_model.dart';

import 'package:fitness_app/features/walk/data/models/walk_model.dart';

abstract class WalkEvent {}

class WalkInitialEvent extends WalkEvent {}

class WalkEditButtonClickedEvent extends WalkEvent {
  final WalkModel walkModel;
  WalkEditButtonClickedEvent(this.walkModel);
}

class WalkDeleteButtonClickedEvent extends WalkEvent {
  final WalkModel walkModel;
  WalkDeleteButtonClickedEvent(this.walkModel);
}

class WalkDeleteAllButtonClickedEvent extends WalkEvent {}

class WalkAddButtonClickedEvent extends WalkEvent {}

class WalkJoinButtonClickedEvent extends WalkEvent {
  WalkParticipantModel walkParticipantModel;
  WalkJoinButtonClickedEvent(this.walkParticipantModel);
}

class WalkLeaveButtonClickedEvent extends WalkEvent {
  WalkParticipantModel walkParticipantModel;
  WalkLeaveButtonClickedEvent(this.walkParticipantModel);
}

class WalkTileNavigateEvent extends WalkEvent {
  final WalkModel walkModel;
  WalkTileNavigateEvent(this.walkModel);
}
