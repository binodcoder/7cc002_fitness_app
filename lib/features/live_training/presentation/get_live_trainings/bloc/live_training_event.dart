import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

abstract class LiveTrainingEvent {}

class LiveTrainingInitialEvent extends LiveTrainingEvent {}

class LiveTrainingEditButtonClickedEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  LiveTrainingEditButtonClickedEvent(this.liveTraining);
}

class LiveTrainingDeleteButtonClickedEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  LiveTrainingDeleteButtonClickedEvent(this.liveTraining);
}

class LiveTrainingDeleteAllButtonClickedEvent extends LiveTrainingEvent {}

class LiveTrainingAddButtonClickedEvent extends LiveTrainingEvent {}

class LiveTrainingTileNavigateEvent extends LiveTrainingEvent {
  final LiveTraining liveTraining;
  LiveTrainingTileNavigateEvent(this.liveTraining);
}

class LiveTrainingDaySelectEvent extends LiveTrainingEvent {
  List<LiveTraining> liveTrainingModels;
  final DateTime selectedDay;
  LiveTrainingDaySelectEvent(this.selectedDay, this.liveTrainingModels);
}
