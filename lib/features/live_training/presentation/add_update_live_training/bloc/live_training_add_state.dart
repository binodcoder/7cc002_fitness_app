import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class LiveTrainingAddState extends Equatable {
  const LiveTrainingAddState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class LiveTrainingAddActionState extends LiveTrainingAddState {
  const LiveTrainingAddActionState();
}

class LiveTrainingAddLoadingState extends LiveTrainingAddActionState {
  const LiveTrainingAddLoadingState();
}

class LiveTrainingAddLoadedSuccessState extends LiveTrainingAddState {
  const LiveTrainingAddLoadedSuccessState();
}

class LiveTrainingAddInitialState extends LiveTrainingAddState {
  const LiveTrainingAddInitialState();
}

class LiveTrainingAddReadyToUpdateState extends LiveTrainingAddState {
  const LiveTrainingAddReadyToUpdateState();
}

class AddLiveTrainingSavedState extends LiveTrainingAddActionState {
  const AddLiveTrainingSavedState();
}

class AddLiveTrainingUpdatedState extends LiveTrainingAddActionState {
  const AddLiveTrainingUpdatedState();
}

class AddLiveTrainingErrorState extends LiveTrainingAddActionState {
  const AddLiveTrainingErrorState();
}
