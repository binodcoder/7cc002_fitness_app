import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';

@immutable
abstract class WalkMediaAddEvent extends Equatable {
  const WalkMediaAddEvent();

  @override
  List<Object?> get props => const [];
}

class WalkMediaAddInitialEvent extends WalkMediaAddEvent {
  const WalkMediaAddInitialEvent();
}

class WalkMediaAddPickFromGalaryButtonPressEvent extends WalkMediaAddEvent {
  const WalkMediaAddPickFromGalaryButtonPressEvent();
}

class WalkMediaAddPickFromCameraButtonPressEvent extends WalkMediaAddEvent {
  const WalkMediaAddPickFromCameraButtonPressEvent();
}

class WalkMediaAddPickVideoButtonPressEvent extends WalkMediaAddEvent {
  const WalkMediaAddPickVideoButtonPressEvent();
}

class WalkMediaAddSaveButtonPressEvent extends WalkMediaAddEvent {
  final WalkMedia newWalkMedia;
  const WalkMediaAddSaveButtonPressEvent({required this.newWalkMedia});

  @override
  List<Object?> get props => [newWalkMedia];
}

class WalkMediaAddUpdateButtonPressEvent extends WalkMediaAddEvent {
  final WalkMedia updatedWalkMedia;
  const WalkMediaAddUpdateButtonPressEvent({required this.updatedWalkMedia});

  @override
  List<Object?> get props => [updatedWalkMedia];
}

class WalkMediaAddReadyToUpdateEvent extends WalkMediaAddEvent {
  final WalkMedia walkMedia;
  const WalkMediaAddReadyToUpdateEvent({required this.walkMedia});

  @override
  List<Object?> get props => [walkMedia];
}
