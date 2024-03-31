abstract class RoutineAddState {
  final String? imagePath;
  RoutineAddState({this.imagePath});
}

abstract class RoutineAddActionState extends RoutineAddState {}

class RoutineAddInitialState extends RoutineAddState {}

class RoutineAddReadyToUpdateState extends RoutineAddState {
  RoutineAddReadyToUpdateState(imagePath) : super(imagePath: imagePath);
}

class AddRoutineImagePickedFromGalaryState extends RoutineAddState {
  AddRoutineImagePickedFromGalaryState(imagePath) : super(imagePath: imagePath);
}

class AddRoutineImagePickedFromCameraState extends RoutineAddState {
  AddRoutineImagePickedFromCameraState(imagePath) : super(imagePath: imagePath);
}

class AddRoutineSavedActionState extends RoutineAddActionState {}

class AddRoutineUpdatedActionState extends RoutineAddActionState {}

class AddRoutineErrorState extends RoutineAddActionState {}
