import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class WalkFormState extends Equatable {
  final String? imagePath;
  const WalkFormState({this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

@immutable
abstract class WalkFormActionState extends WalkFormState {
  const WalkFormActionState({super.imagePath});
}

class WalkFormInitial extends WalkFormState {
  const WalkFormInitial({super.imagePath});
}

class WalkFormReadyToEditState extends WalkFormState {
  const WalkFormReadyToEditState({required String imagePath})
      : super(imagePath: imagePath);
}

class WalkFormImagePickedFromGallery extends WalkFormState {
  const WalkFormImagePickedFromGallery({required String imagePath})
      : super(imagePath: imagePath);
}

class WalkFormImagePickedFromCamera extends WalkFormState {
  const WalkFormImagePickedFromCamera({required String imagePath})
      : super(imagePath: imagePath);
}

class WalkFormLoading extends WalkFormActionState {
  const WalkFormLoading();
}

class WalkFormCreateSuccess extends WalkFormActionState {
  const WalkFormCreateSuccess();
}

class WalkFormUpdateSuccess extends WalkFormActionState {
  const WalkFormUpdateSuccess();
}

class WalkFormError extends WalkFormActionState {
  const WalkFormError();
}
