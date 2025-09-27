import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkListEvent extends Equatable {
  const WalkListEvent();

  @override
  List<Object?> get props => const [];
}

class WalkListInitialized extends WalkListEvent {
  const WalkListInitialized();
}

class WalkEditRequested extends WalkListEvent {
  final Walk walk;
  const WalkEditRequested({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkDeleteRequested extends WalkListEvent {
  final Walk walk;
  const WalkDeleteRequested({required this.walk});

  @override
  List<Object?> get props => [walk];
}

class WalkDeleteAllRequested extends WalkListEvent {
  const WalkDeleteAllRequested();
}

class WalkCreateRequested extends WalkListEvent {
  const WalkCreateRequested();
}

class WalkJoinRequested extends WalkListEvent {
  final WalkParticipant walkParticipant;
  const WalkJoinRequested({required this.walkParticipant});

  @override
  List<Object?> get props => [walkParticipant];
}

class WalkLeaveRequested extends WalkListEvent {
  final WalkParticipant walkParticipant;
  const WalkLeaveRequested({required this.walkParticipant});

  @override
  List<Object?> get props => [walkParticipant];
}

class WalkDetailsRequested extends WalkListEvent {
  final Walk walk;
  const WalkDetailsRequested({required this.walk});

  @override
  List<Object?> get props => [walk];
}
