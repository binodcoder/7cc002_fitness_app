import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

@immutable
abstract class LiveTrainingState extends Equatable {
  const LiveTrainingState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class LiveTrainingActionState extends LiveTrainingState {
  const LiveTrainingActionState();
}

class LiveTrainingInitialState extends LiveTrainingState {
  const LiveTrainingInitialState();
}

class LiveTrainingLoadingState extends LiveTrainingState {
  const LiveTrainingLoadingState();
}

class LiveTrainingLoadedSuccessState extends LiveTrainingState {
  final List<LiveTraining> liveTrainings;
  const LiveTrainingLoadedSuccessState({required this.liveTrainings});
  LiveTrainingLoadedSuccessState copyWith({List<LiveTraining>? liveTrainings}) {
    return LiveTrainingLoadedSuccessState(
        liveTrainings: liveTrainings ?? this.liveTrainings);
  }

  @override
  List<Object?> get props => [liveTrainings];
}

class LiveTrainingErrorState extends LiveTrainingState {
  final String message;
  const LiveTrainingErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LiveTrainingShowErrorActionState extends LiveTrainingActionState {
  final String message;
  const LiveTrainingShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LiveTrainingNavigateToAddLiveTrainingActionState
    extends LiveTrainingActionState {
  const LiveTrainingNavigateToAddLiveTrainingActionState();
}

class LiveTrainingNavigateToDetailPageActionState
    extends LiveTrainingActionState {
  final LiveTraining liveTraining;

  const LiveTrainingNavigateToDetailPageActionState(
      {required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingNavigateToUpdatePageActionState
    extends LiveTrainingActionState {
  final LiveTraining liveTraining;
  const LiveTrainingNavigateToUpdatePageActionState(
      {required this.liveTraining});

  @override
  List<Object?> get props => [liveTraining];
}

class LiveTrainingItemDeletedActionState extends LiveTrainingActionState {
  const LiveTrainingItemDeletedActionState();
}

class LiveTrainingDaySelectedState extends LiveTrainingState {
  final List<LiveTraining> liveTrainings;

  const LiveTrainingDaySelectedState({required this.liveTrainings});

  @override
  List<Object?> get props => [liveTrainings];
}

class LiveTrainingItemsDeletedActionState extends LiveTrainingActionState {
  const LiveTrainingItemsDeletedActionState();
}
