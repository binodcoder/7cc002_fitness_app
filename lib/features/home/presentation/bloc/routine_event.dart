import '../../../../core/model/routine_model.dart';

abstract class RoutineEvent {}

class RoutineInitialEvent extends RoutineEvent {}

class PostEditButtonClickedEvent extends RoutineEvent {}

class PostDeleteButtonClickedEvent extends RoutineEvent {
  final RoutineModel postModel;
  PostDeleteButtonClickedEvent(this.postModel);
}

class PostDeleteAllButtonClickedEvent extends RoutineEvent {}

class PostAddButtonClickedEvent extends RoutineEvent {}

class RoutineTileNavigateEvent extends RoutineEvent {
  final RoutineModel routineModel;
  RoutineTileNavigateEvent(this.routineModel);
}

 
