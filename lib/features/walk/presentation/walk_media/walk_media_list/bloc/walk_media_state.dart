import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';

@immutable
abstract class WalkMediaState extends Equatable {
  const WalkMediaState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class WalkMediaActionState extends WalkMediaState {
  const WalkMediaActionState();
}

class WalkMediaInitialState extends WalkMediaState {
  const WalkMediaInitialState();
}

class WalkMediaLoadingState extends WalkMediaState {
  const WalkMediaLoadingState();
}

class WalkMediaLoadedSuccessState extends WalkMediaState {
  final List<WalkMedia> walkMediaList;
  const WalkMediaLoadedSuccessState(this.walkMediaList);
  WalkMediaLoadedSuccessState copyWith({List<WalkMedia>? walkMediaList}) {
    return WalkMediaLoadedSuccessState(walkMediaList ?? this.walkMediaList);
  }

  @override
  List<Object?> get props => [walkMediaList];
}

class WalkMediaErrorState extends WalkMediaState {
  final String message;
  const WalkMediaErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class WalkMediaShowErrorActionState extends WalkMediaActionState {
  final String message;
  const WalkMediaShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class WalkMediaNavigateToAddWalkMediaActionState extends WalkMediaActionState {
  final int walkId;
  const WalkMediaNavigateToAddWalkMediaActionState(this.walkId);

  @override
  List<Object?> get props => [walkId];
}

class WalkMediaNavigateToDetailPageActionState extends WalkMediaActionState {
  final WalkMedia walkMedia;

  const WalkMediaNavigateToDetailPageActionState(this.walkMedia);

  @override
  List<Object?> get props => [walkMedia];
}

class WalkMediaNavigateToUpdatePageActionState extends WalkMediaActionState {
  final WalkMedia walkMedia;

  const WalkMediaNavigateToUpdatePageActionState(this.walkMedia);

  @override
  List<Object?> get props => [walkMedia];
}

class WalkMediaItemDeletedActionState extends WalkMediaActionState {
  const WalkMediaItemDeletedActionState();
}

class WalkMediaItemSelectedActionState extends WalkMediaActionState {
  const WalkMediaItemSelectedActionState();
}

class WalkMediaItemsDeletedActionState extends WalkMediaActionState {
  const WalkMediaItemsDeletedActionState();
}
