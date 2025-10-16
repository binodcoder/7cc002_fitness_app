import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class WalkMediaAddState extends Equatable {
  final String? imagePath;
  const WalkMediaAddState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class WalkMediaAddActionState extends WalkMediaAddState {
  const WalkMediaAddActionState({super.imagePath});
}

class WalkMediaAddInitialState extends WalkMediaAddState {
  const WalkMediaAddInitialState({super.imagePath});
}

class WalkMediaAddReadyToUpdateState extends WalkMediaAddState {
  const WalkMediaAddReadyToUpdateState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkMediaImagePickedFromGalaryState extends WalkMediaAddState {
  const AddWalkMediaImagePickedFromGalaryState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkMediaImagePickedFromCameraState extends WalkMediaAddState {
  const AddWalkMediaImagePickedFromCameraState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkMediaVideoPickedState extends WalkMediaAddState {
  const AddWalkMediaVideoPickedState({required String videoPath})
      : super(imagePath: videoPath);
}

class AddWalkMediaLoadingState extends WalkMediaAddActionState {
  const AddWalkMediaLoadingState();
}

class AddWalkMediaSavedState extends WalkMediaAddActionState {
  const AddWalkMediaSavedState();
}

class AddWalkMediaUpdatedState extends WalkMediaAddActionState {
  const AddWalkMediaUpdatedState();
}

class AddWalkMediaErrorState extends WalkMediaAddActionState {
  const AddWalkMediaErrorState();
}
