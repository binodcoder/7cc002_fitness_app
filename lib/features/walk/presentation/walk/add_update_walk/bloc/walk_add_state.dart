abstract class WalkAddState {
  final String? imagePath;
  WalkAddState({this.imagePath});
}

abstract class WalkAddActionState extends WalkAddState {}

class WalkAddInitialState extends WalkAddState {}

class WalkAddReadyToUpdateState extends WalkAddState {
  WalkAddReadyToUpdateState(imagePath) : super(imagePath: imagePath);
}

class AddWalkImagePickedFromGalaryState extends WalkAddState {
  AddWalkImagePickedFromGalaryState(imagePath) : super(imagePath: imagePath);
}

class AddWalkImagePickedFromCameraState extends WalkAddState {
  AddWalkImagePickedFromCameraState(imagePath) : super(imagePath: imagePath);
}

class AddWalkLoadingState extends WalkAddActionState {}

class AddWalkSavedState extends WalkAddActionState {}

class AddWalkUpdatedState extends WalkAddActionState {}

class AddWalkErrorState extends WalkAddActionState {}
