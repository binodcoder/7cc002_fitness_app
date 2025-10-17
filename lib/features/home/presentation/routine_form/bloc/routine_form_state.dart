import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RoutineFormState extends Equatable {
  final String? imagePath;
  const RoutineFormState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class RoutineFormActionState extends RoutineFormState {
  const RoutineFormActionState({super.imagePath});
}

class RoutineFormInitialState extends RoutineFormState {
  const RoutineFormInitialState({super.imagePath});
}

class RoutineFormReadyToUpdateState extends RoutineFormState {
  const RoutineFormReadyToUpdateState({required String imagePath})
      : super(imagePath: imagePath);
}

class RoutineFormImagePickedFromGalleryState extends RoutineFormState {
  const RoutineFormImagePickedFromGalleryState({required String imagePath})
      : super(imagePath: imagePath);
}

class RoutineFormImagePickedFromCameraState extends RoutineFormState {
  const RoutineFormImagePickedFromCameraState({required String imagePath})
      : super(imagePath: imagePath);
}

class RoutineFormLoadingState extends RoutineFormActionState {
  const RoutineFormLoadingState();
}

class RoutineFormSavedActionState extends RoutineFormActionState {
  const RoutineFormSavedActionState();
}

class RoutineFormUpdatedActionState extends RoutineFormActionState {
  const RoutineFormUpdatedActionState();
}

class RoutineFormErrorState extends RoutineFormActionState {
  const RoutineFormErrorState();
}
