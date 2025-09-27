import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';

@immutable
abstract class WalkMediaEvent extends Equatable {
  const WalkMediaEvent();

  @override
  List<Object?> get props => const [];
}

class WalkMediaInitialEvent extends WalkMediaEvent {
  final int walkId;
  const WalkMediaInitialEvent(this.walkId);
}

class WalkMediaEditButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaEditButtonClickedEvent(this.walkMedia);
}

class WalkMediaDeleteButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaDeleteButtonClickedEvent(this.walkMedia);
}

class WalkMediaAddButtonClickedEvent extends WalkMediaEvent {
  final int walkId;
  const WalkMediaAddButtonClickedEvent(this.walkId);
}

class WalkMediaTileNavigateEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaTileNavigateEvent({required this.walkMedia});

  @override
  List<Object?> get props => [walkMedia];
}

