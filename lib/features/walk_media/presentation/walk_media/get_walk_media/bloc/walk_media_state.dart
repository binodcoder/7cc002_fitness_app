import 'package:fitness_app/core/model/walk_media_model.dart';

abstract class WalkMediaState {}

abstract class WalkMediaActionState extends WalkMediaState {}

class WalkMediaInitialState extends WalkMediaState {}

class WalkMediaLoadingState extends WalkMediaState {}

class WalkMediaLoadedSuccessState extends WalkMediaState {
  final List<WalkMediaModel> walkMediaModelList;
  WalkMediaLoadedSuccessState(this.walkMediaModelList);
  WalkMediaLoadedSuccessState copyWith({List<WalkMediaModel>? walkMediaModelList}) {
    return WalkMediaLoadedSuccessState(walkMediaModelList ?? this.walkMediaModelList);
  }
}

class WalkMediaErrorState extends WalkMediaState {}

class WalkMediaNavigateToAddWalkMediaActionState extends WalkMediaActionState {
  final int walkId;
  WalkMediaNavigateToAddWalkMediaActionState(this.walkId);
}

class WalkMediaNavigateToDetailPageActionState extends WalkMediaActionState {
  final WalkMediaModel walkMediaModel;

  WalkMediaNavigateToDetailPageActionState(this.walkMediaModel);
}

class WalkMediaNavigateToUpdatePageActionState extends WalkMediaActionState {
  final WalkMediaModel walkMediaModel;

  WalkMediaNavigateToUpdatePageActionState(this.walkMediaModel);
}

class WalkMediaItemDeletedActionState extends WalkMediaActionState {}

class WalkMediaItemSelectedActionState extends WalkMediaActionState {}

class WalkMediaItemsDeletedActionState extends WalkMediaActionState {}
