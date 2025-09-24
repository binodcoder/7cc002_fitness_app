import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

abstract class LiveTrainingState {}

abstract class LiveTrainingActionState extends LiveTrainingState {}

class LiveTrainingInitialState extends LiveTrainingState {}

class LiveTrainingLoadingState extends LiveTrainingState {}

class LiveTrainingLoadedSuccessState extends LiveTrainingState {
  final List<LiveTraining> liveTrainings;
  LiveTrainingLoadedSuccessState(this.liveTrainings);
  LiveTrainingLoadedSuccessState copyWith({List<LiveTraining>? liveTrainings}) {
    return LiveTrainingLoadedSuccessState(liveTrainings ?? this.liveTrainings);
  }
}

class LiveTrainingErrorState extends LiveTrainingState {}

class LiveTrainingNavigateToAddLiveTrainingActionState extends LiveTrainingActionState {}

class LiveTrainingNavigateToDetailPageActionState extends LiveTrainingActionState {
  final LiveTraining liveTraining;

  LiveTrainingNavigateToDetailPageActionState(this.liveTraining);
}

class LiveTrainingNavigateToUpdatePageActionState extends LiveTrainingActionState {
  final LiveTraining liveTraining;
  LiveTrainingNavigateToUpdatePageActionState(this.liveTraining);
}

class LiveTrainingItemDeletedActionState extends LiveTrainingActionState {}

class LiveTrainingDaySelectedState extends LiveTrainingState {
  final List<LiveTraining> liveTrainings;

  LiveTrainingDaySelectedState(this.liveTrainings);
}

class LiveTrainingItemsDeletedActionState extends LiveTrainingActionState {}
