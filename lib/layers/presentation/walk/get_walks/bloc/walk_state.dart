import '../../../../../core/model/walk_model.dart';

abstract class WalkState {}

abstract class WalkActionState extends WalkState {}

class WalkInitialState extends WalkState {}

class WalkLoadingState extends WalkState {}

class WalkLoadedSuccessState extends WalkState {
  final List<WalkModel> walkModelList;
  WalkLoadedSuccessState(this.walkModelList);
  WalkLoadedSuccessState copyWith({List<WalkModel>? walkModelList}) {
    return WalkLoadedSuccessState(walkModelList ?? this.walkModelList);
  }
}

class WalkErrorState extends WalkState {}

class WalkNavigateToAddWalkActionState extends WalkActionState {}

class WalkNavigateToDetailPageActionState extends WalkActionState {
  final WalkModel walkModel;

  WalkNavigateToDetailPageActionState(this.walkModel);
}

class WalkNavigateToUpdatePageActionState extends WalkActionState {}

class WalkItemDeletedActionState extends WalkActionState {}

class WalkItemSelectedActionState extends WalkActionState {}

class WalkItemsDeletedActionState extends WalkActionState {}
