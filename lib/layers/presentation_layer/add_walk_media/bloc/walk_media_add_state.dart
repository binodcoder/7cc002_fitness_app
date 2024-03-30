abstract class WalkMediaAddState {
  final String? imagePath;
  WalkMediaAddState({this.imagePath});
}

abstract class WalkMediaAddActionState extends WalkMediaAddState {}

class WalkMediaAddInitialState extends WalkMediaAddState {}

class WalkMediaAddReadyToUpdateState extends WalkMediaAddState {
  WalkMediaAddReadyToUpdateState(imagePath) : super(imagePath: imagePath);
}

class AddWalkMediaImagePickedFromGalaryState extends WalkMediaAddState {
  AddWalkMediaImagePickedFromGalaryState(imagePath) : super(imagePath: imagePath);
}

class AddWalkMediaImagePickedFromCameraState extends WalkMediaAddState {
  AddWalkMediaImagePickedFromCameraState(imagePath) : super(imagePath: imagePath);
}

class AddWalkMediaSavedState extends WalkMediaAddActionState {}

class AddWalkMediaUpdatedState extends WalkMediaAddActionState {}

class AddWalkMediaErrorState extends WalkMediaAddActionState {}
