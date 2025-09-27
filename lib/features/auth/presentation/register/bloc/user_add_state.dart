import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class UserAddState extends Equatable {
  final String? imagePath;
  const UserAddState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class UserAddActionState extends UserAddState {
  const UserAddActionState({super.imagePath});
}

class UserAddInitialState extends UserAddState {
  const UserAddInitialState({super.imagePath});
}

class UserAddReadyToUpdateState extends UserAddState {
  const UserAddReadyToUpdateState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddUserImagePickedFromGalaryState extends UserAddState {
  const AddUserImagePickedFromGalaryState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddUserImagePickedFromCameraState extends UserAddState {
  const AddUserImagePickedFromCameraState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddUserLoadingState extends UserAddActionState {
  const AddUserLoadingState();
}

class AddUserSavedState extends UserAddActionState {
  const AddUserSavedState();
}

class AddUserUpdatedState extends UserAddActionState {
  const AddUserUpdatedState();
}

class AddUserErrorState extends UserAddActionState {
  final String message;

  const AddUserErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
