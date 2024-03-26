abstract class PostAddState {
  final String? imagePath;
  PostAddState({this.imagePath});
}

abstract class PostAddActionState extends PostAddState {}

class PostAddInitialState extends PostAddState {}

class PostAddReadyToUpdateState extends PostAddState {
  PostAddReadyToUpdateState(imagePath) : super(imagePath: imagePath);
}

class AddPostImagePickedFromGalaryState extends PostAddState {
  AddPostImagePickedFromGalaryState(imagePath) : super(imagePath: imagePath);
}

class AddPostImagePickedFromCameraState extends PostAddState {
  AddPostImagePickedFromCameraState(imagePath) : super(imagePath: imagePath);
}

class AddPostSavedState extends PostAddActionState {}

class AddPostUpdatedState extends PostAddActionState {}

class AddPostErrorState extends PostAddActionState {}
