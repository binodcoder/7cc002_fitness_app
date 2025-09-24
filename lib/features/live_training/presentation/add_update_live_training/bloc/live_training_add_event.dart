import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

abstract class LiveTrainingAddEvent {}

class LiveTrainingAddInitialEvent extends LiveTrainingAddEvent {}

class LiveTrainingAddSaveButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  LiveTrainingAddSaveButtonPressEvent(this.liveTraining);
}

class LiveTrainingAddUpdateButtonPressEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  LiveTrainingAddUpdateButtonPressEvent(this.liveTraining);
}

class LiveTrainingAddReadyToUpdateEvent extends LiveTrainingAddEvent {
  final LiveTraining liveTraining;
  LiveTrainingAddReadyToUpdateEvent(this.liveTraining);
}
