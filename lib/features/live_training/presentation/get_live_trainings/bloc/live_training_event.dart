import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

@immutable
abstract class LiveTrainingEvent extends Equatable {
  const LiveTrainingEvent();

  @override
  List<Object?> get props => const [];
}

class LiveTrainingInitialEvent extends LiveTrainingEvent {
  const LiveTrainingInitialEvent();
}

class LiveTrainingEditButtonClickedEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  const LiveTrainingEditButtonClickedEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingDeleteButtonClickedEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  const LiveTrainingDeleteButtonClickedEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingDeleteAllButtonClickedEvent extends LiveTrainingEvent {
  const LiveTrainingDeleteAllButtonClickedEvent();
}

class LiveTrainingAddButtonClickedEvent extends LiveTrainingEvent {
  const LiveTrainingAddButtonClickedEvent();
}

class LiveTrainingTileNavigateEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  const LiveTrainingTileNavigateEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingDaySelectEvent extends LiveTrainingEvent {
  final List<LiveTraining> liveTrainingModels;
  final DateTime selectedDay;
  const LiveTrainingDaySelectEvent(
      {required this.selectedDay, required this.liveTrainingModels});

  @override
  List<Object?> get props => [selectedDay, liveTrainingModels];
}
