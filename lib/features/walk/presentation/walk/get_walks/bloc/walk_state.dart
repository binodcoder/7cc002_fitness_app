import 'package:fitness_app/features/walk/domain/entities/walk.dart';

abstract class WalkState {}

abstract class WalkActionState extends WalkState {}

class WalkInitialState extends WalkState {}

class WalkLoadingState extends WalkState {}

class WalkLoadedSuccessState extends WalkState {
  final List<Walk> walks;
  WalkLoadedSuccessState(this.walks);
  WalkLoadedSuccessState copyWith({List<Walk>? walks}) {
    return WalkLoadedSuccessState(walks ?? this.walks);
  }
}

class WalkErrorState extends WalkState {}

class WalkNavigateToAddWalkActionState extends WalkActionState {}

class WalkNavigateToDetailPageActionState extends WalkActionState {
  final Walk walk;

  WalkNavigateToDetailPageActionState(this.walk);
}

class WalkNavigateToUpdatePageActionState extends WalkActionState {
  final Walk walk;

  WalkNavigateToUpdatePageActionState(this.walk);
}

class WalkItemDeletedActionState extends WalkActionState {}

class WalkItemSelectedActionState extends WalkActionState {}

class WalkItemsDeletedActionState extends WalkActionState {}

class WalkJoinedActionState extends WalkActionState {}

class WalkLeftActionState extends WalkActionState {}
