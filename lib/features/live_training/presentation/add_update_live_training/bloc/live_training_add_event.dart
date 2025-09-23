import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';

abstract class LiveTrainingAddEvent {}

class LiveTrainingAddInitialEvent extends LiveTrainingAddEvent {}

class LiveTrainingAddSaveButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingAddSaveButtonPressEvent(this.liveTrainingModel);
}

class LiveTrainingAddUpdateButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingAddUpdateButtonPressEvent(this.liveTrainingModel);
}

class LiveTrainingAddReadyToUpdateEvent extends LiveTrainingAddEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingAddReadyToUpdateEvent(this.liveTrainingModel);
}
