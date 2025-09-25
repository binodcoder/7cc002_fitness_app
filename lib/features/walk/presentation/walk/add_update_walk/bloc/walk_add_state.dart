import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class WalkAddState extends Equatable {
  final String? imagePath;
  const WalkAddState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class WalkAddActionState extends WalkAddState {
  const WalkAddActionState({super.imagePath});
}

class WalkAddInitialState extends WalkAddState {
  const WalkAddInitialState({super.imagePath});
}

class WalkAddReadyToUpdateState extends WalkAddState {
  const WalkAddReadyToUpdateState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkImagePickedFromGalaryState extends WalkAddState {
  const AddWalkImagePickedFromGalaryState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkImagePickedFromCameraState extends WalkAddState {
  const AddWalkImagePickedFromCameraState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddWalkLoadingState extends WalkAddActionState {
  const AddWalkLoadingState();
}

class AddWalkSavedState extends WalkAddActionState {
  const AddWalkSavedState();
}

class AddWalkUpdatedState extends WalkAddActionState {
  const AddWalkUpdatedState();
}

class AddWalkErrorState extends WalkAddActionState {
  const AddWalkErrorState();
}
