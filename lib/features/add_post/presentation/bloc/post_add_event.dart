import '../../../../core/model/routine_model.dart';

abstract class PostAddEvent {}

class PostAddInitialEvent extends PostAddEvent {}

class PostAddPickFromGalaryButtonPressEvent extends PostAddEvent {}

class PostAddPickFromCameraButtonPressEvent extends PostAddEvent {}

class PostAddSaveButtonPressEvent extends PostAddEvent {
  final RoutineModel newPost;
  PostAddSaveButtonPressEvent(this.newPost);
}

class PostAddUpdateButtonPressEvent extends PostAddEvent {
  final RoutineModel updatedPost;
  PostAddUpdateButtonPressEvent(this.updatedPost);
}

class PostAddReadyToUpdateEvent extends PostAddEvent {
  final RoutineModel postModel;
  PostAddReadyToUpdateEvent(this.postModel);
}
