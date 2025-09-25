import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkEvent extends Equatable {
  const WalkEvent();

  @override
  List<Object?> get props => const [];
}

class WalkInitialEvent extends WalkEvent {
  const WalkInitialEvent();
}

class WalkEditButtonClickedEvent extends WalkEvent {
  final Walk walk;
  const WalkEditButtonClickedEvent({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkDeleteButtonClickedEvent extends WalkEvent {
  final Walk walk;
  const WalkDeleteButtonClickedEvent({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkDeleteAllButtonClickedEvent extends WalkEvent {
  const WalkDeleteAllButtonClickedEvent();
}

class WalkAddButtonClickedEvent extends WalkEvent {
  const WalkAddButtonClickedEvent();
}

class WalkJoinButtonClickedEvent extends WalkEvent {
  final WalkParticipant walkParticipant;
  const WalkJoinButtonClickedEvent({required this.walkParticipant});

  @override
  List<Object?> get props => [walkParticipant];
}

class WalkLeaveButtonClickedEvent extends WalkEvent {
  final WalkParticipant walkParticipant;
  const WalkLeaveButtonClickedEvent({required this.walkParticipant});

  @override
  List<Object?> get props => [walkParticipant];
}

class WalkTileNavigateEvent extends WalkEvent {
  final Walk walk;
  const WalkTileNavigateEvent({required this.walk});

  @override
  List<Object?> get props => [walk];
}
