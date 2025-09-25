import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

@immutable
abstract class LiveTrainingAddEvent extends Equatable {
  const LiveTrainingAddEvent();

  @override
  List<Object?> get props => const [];
}

class LiveTrainingAddInitialEvent extends LiveTrainingAddEvent {
  const LiveTrainingAddInitialEvent();
}

class LiveTrainingAddSaveButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  const LiveTrainingAddSaveButtonPressEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingAddUpdateButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  const LiveTrainingAddUpdateButtonPressEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingAddReadyToUpdateEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  const LiveTrainingAddReadyToUpdateEvent({required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}
