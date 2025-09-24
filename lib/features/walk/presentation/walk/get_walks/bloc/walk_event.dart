import 'package:fitness_app/features/walk/domain/entities/walk.dart';

abstract class WalkEvent {}

class WalkInitialEvent extends WalkEvent {}

class WalkEditButtonClickedEvent extends WalkEvent {
  final Walk walk;
  WalkEditButtonClickedEvent(this.walk);
}

class WalkDeleteButtonClickedEvent extends WalkEvent {
  final Walk walk;
  WalkDeleteButtonClickedEvent(this.walk);
}

class WalkDeleteAllButtonClickedEvent extends WalkEvent {}

class WalkAddButtonClickedEvent extends WalkEvent {}

class WalkJoinButtonClickedEvent extends WalkEvent {
  WalkParticipant walkParticipant;
  WalkJoinButtonClickedEvent(this.walkParticipant);
}

class WalkLeaveButtonClickedEvent extends WalkEvent {
  WalkParticipant walkParticipant;
  WalkLeaveButtonClickedEvent(this.walkParticipant);
}

class WalkTileNavigateEvent extends WalkEvent {
  final Walk walk;
  WalkTileNavigateEvent(this.walk);
}
