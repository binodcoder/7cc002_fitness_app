import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';

abstract class WalkMediaState {}

abstract class WalkMediaActionState extends WalkMediaState {}

class WalkMediaInitialState extends WalkMediaState {}

class WalkMediaLoadingState extends WalkMediaState {}

class WalkMediaLoadedSuccessState extends WalkMediaState {
  final List<WalkMedia> walkMediaList;
  WalkMediaLoadedSuccessState(this.walkMediaList);
  WalkMediaLoadedSuccessState copyWith({List<WalkMedia>? walkMediaList}) {
    return WalkMediaLoadedSuccessState(walkMediaList ?? this.walkMediaList);
  }
}

class WalkMediaErrorState extends WalkMediaState {}

class WalkMediaNavigateToAddWalkMediaActionState extends WalkMediaActionState {
  final int walkId;
  WalkMediaNavigateToAddWalkMediaActionState(this.walkId);
}

class WalkMediaNavigateToDetailPageActionState extends WalkMediaActionState {
  final WalkMedia walkMedia;

  WalkMediaNavigateToDetailPageActionState(this.walkMedia);
}

class WalkMediaNavigateToUpdatePageActionState extends WalkMediaActionState {
  final WalkMedia walkMedia;

  WalkMediaNavigateToUpdatePageActionState(this.walkMedia);
}

class WalkMediaItemDeletedActionState extends WalkMediaActionState {}

class WalkMediaItemSelectedActionState extends WalkMediaActionState {}

class WalkMediaItemsDeletedActionState extends WalkMediaActionState {}
