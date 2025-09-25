import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';

@immutable
abstract class WalkMediaEvent extends Equatable {
  const WalkMediaEvent();

  @override
  List<Object?> get props => const [];
}

class WalkMediaInitialEvent extends WalkMediaEvent {
  final int walkId;
  const WalkMediaInitialEvent(this.walkId);

  @override
  List<Object?> get props => [walkId];
}

class WalkMediaEditButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaEditButtonClickedEvent(this.walkMedia);

  @override
  List<Object?> get props => [walkMedia];
}

class WalkMediaDeleteButtonClickedEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaDeleteButtonClickedEvent(this.walkMedia);

  @override
  List<Object?> get props => [walkMedia];
}

class WalkMediaDeleteAllButtonClickedEvent extends WalkMediaEvent {
  const WalkMediaDeleteAllButtonClickedEvent();
}

class WalkMediaAddButtonClickedEvent extends WalkMediaEvent {
  final int walkId;
  const WalkMediaAddButtonClickedEvent(this.walkId);

  @override
  List<Object?> get props => [walkId];
}

class WalkMediaTileNavigateEvent extends WalkMediaEvent {
  final WalkMedia walkMedia;
  const WalkMediaTileNavigateEvent(this.walkMedia);

  @override
  List<Object?> get props => [walkMedia];
}
