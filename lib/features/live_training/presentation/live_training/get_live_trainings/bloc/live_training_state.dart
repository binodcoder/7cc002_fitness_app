import 'package:fitness_app/core/model/live_training_model.dart';

abstract class LiveTrainingState {}

abstract class LiveTrainingActionState extends LiveTrainingState {}

class LiveTrainingInitialState extends LiveTrainingState {}

class LiveTrainingLoadingState extends LiveTrainingState {}

class LiveTrainingLoadedSuccessState extends LiveTrainingState {
  final List<LiveTrainingModel> liveTrainingModels;
  LiveTrainingLoadedSuccessState(this.liveTrainingModels);
  LiveTrainingLoadedSuccessState copyWith({List<LiveTrainingModel>? liveTrainingModels}) {
    return LiveTrainingLoadedSuccessState(liveTrainingModels ?? this.liveTrainingModels);
  }
}

class LiveTrainingErrorState extends LiveTrainingState {}

class LiveTrainingNavigateToAddLiveTrainingActionState extends LiveTrainingActionState {}

class LiveTrainingNavigateToDetailPageActionState extends LiveTrainingActionState {
  final LiveTrainingModel liveTrainingModel;

  LiveTrainingNavigateToDetailPageActionState(this.liveTrainingModel);
}

class LiveTrainingNavigateToUpdatePageActionState extends LiveTrainingActionState {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingNavigateToUpdatePageActionState(this.liveTrainingModel);
}

class LiveTrainingItemDeletedActionState extends LiveTrainingActionState {}

class LiveTrainingDaySelectedState extends LiveTrainingState {
  final List<LiveTrainingModel> liveTrainingModels;

  LiveTrainingDaySelectedState(this.liveTrainingModels);
}

class LiveTrainingItemsDeletedActionState extends LiveTrainingActionState {}
