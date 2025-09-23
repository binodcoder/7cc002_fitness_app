abstract class LiveTrainingAddState {}

abstract class LiveTrainingAddActionState extends LiveTrainingAddState {}

class LiveTrainingAddLoadingState extends LiveTrainingAddActionState {}

class LiveTrainingAddLoadedSuccessState extends LiveTrainingAddState {
  // final SyncModel syncModel;
  // LiveTrainingAddLoadedSuccessState(this.syncModel);
  // LiveTrainingAddLoadedSuccessState copyWith({SyncModel? syncModel}) {
  //   return LiveTrainingAddLoadedSuccessState(syncModel ?? this.syncModel);
  // }
}

class LiveTrainingAddInitialState extends LiveTrainingAddState {}

class LiveTrainingAddReadyToUpdateState extends LiveTrainingAddState {}

class AddLiveTrainingSavedState extends LiveTrainingAddActionState {}

class AddLiveTrainingUpdatedState extends LiveTrainingAddActionState {}

class AddLiveTrainingErrorState extends LiveTrainingAddActionState {}
