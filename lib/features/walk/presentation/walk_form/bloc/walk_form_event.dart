import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

@immutable
abstract class WalkFormEvent extends Equatable {
  const WalkFormEvent();

  @override
  List<Object?> get props => const [];
}

class WalkFormInitialized extends WalkFormEvent {
  const WalkFormInitialized();
}

class WalkFormPickFromGalleryPressed extends WalkFormEvent {
  const WalkFormPickFromGalleryPressed();
}

class WalkFormPickFromCameraPressed extends WalkFormEvent {
  const WalkFormPickFromCameraPressed();
}

class WalkFormCreatePressed extends WalkFormEvent {
  final Walk newWalk;
  const WalkFormCreatePressed({required this.newWalk});

  @override
  List<Object?> get props => [newWalk];
}

class WalkFormUpdatePressed extends WalkFormEvent {
  final Walk updatedWalk;
  const WalkFormUpdatePressed({required this.updatedWalk});

  @override
  List<Object?> get props => [updatedWalk];
}

class WalkFormReadyToEdit extends WalkFormEvent {
  final Walk walk;
  const WalkFormReadyToEdit({required this.walk});

  @override
  List<Object?> get props => [walk];
}
