import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RoutineAddState extends Equatable {
  final String? imagePath;
  const RoutineAddState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class RoutineAddActionState extends RoutineAddState {
  const RoutineAddActionState({super.imagePath});
}

class RoutineAddInitialState extends RoutineAddState {
  const RoutineAddInitialState({super.imagePath});
}

class RoutineAddReadyToUpdateState extends RoutineAddState {
  const RoutineAddReadyToUpdateState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddRoutineImagePickedFromGalaryState extends RoutineAddState {
  const AddRoutineImagePickedFromGalaryState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddRoutineImagePickedFromCameraState extends RoutineAddState {
  const AddRoutineImagePickedFromCameraState({required String imagePath})
      : super(imagePath: imagePath);
}

class AddRoutineLoadingState extends RoutineAddActionState {
  const AddRoutineLoadingState();
}

class AddRoutineSavedActionState extends RoutineAddActionState {
  const AddRoutineSavedActionState();
}

class AddRoutineUpdatedActionState extends RoutineAddActionState {
  const AddRoutineUpdatedActionState();
}

class AddRoutineErrorState extends RoutineAddActionState {
  const AddRoutineErrorState();
}
