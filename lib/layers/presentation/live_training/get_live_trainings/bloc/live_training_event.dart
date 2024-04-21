import '../../../../../core/model/live_training_model.dart';

abstract class LiveTrainingEvent {}

class LiveTrainingInitialEvent extends LiveTrainingEvent {}

class LiveTrainingEditButtonClickedEvent extends LiveTrainingEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingEditButtonClickedEvent(this.liveTrainingModel);
}

class LiveTrainingDeleteButtonClickedEvent extends LiveTrainingEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingDeleteButtonClickedEvent(this.liveTrainingModel);
}

class LiveTrainingDeleteAllButtonClickedEvent extends LiveTrainingEvent {}

class LiveTrainingAddButtonClickedEvent extends LiveTrainingEvent {}

class LiveTrainingTileNavigateEvent extends LiveTrainingEvent {
  final LiveTrainingModel liveTrainingModel;
  LiveTrainingTileNavigateEvent(this.liveTrainingModel);
}

class LiveTrainingDaySelectEvent extends LiveTrainingEvent {
  List<LiveTrainingModel> liveTrainingModels;
  final DateTime selectedDay;
  LiveTrainingDaySelectEvent(this.selectedDay, this.liveTrainingModels);
}
