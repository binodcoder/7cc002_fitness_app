
import '../../../../core/model/routine_model.dart';

abstract class RoutineState {}

abstract class RoutineActionState extends RoutineState {}

class RoutineInitialState extends RoutineState {}

class RoutineLoadingState extends RoutineState {}

class RoutineLoadedSuccessState extends RoutineState {
  final List<RoutineModel> routineModelList;
  RoutineLoadedSuccessState(this.routineModelList);
  RoutineLoadedSuccessState copyWith({List<RoutineModel>? routineModelList}) {
    return RoutineLoadedSuccessState(routineModelList ?? this.routineModelList);
  }
}

class RoutineErrorState extends RoutineState {}

class RoutineNavigateToAddRoutineActionState extends RoutineActionState {}

class RoutineNavigateToDetailPageActionState extends RoutineActionState {
  final RoutineModel routineModel;

  RoutineNavigateToDetailPageActionState(this.routineModel);
}

class RoutineNavigateToUpdatePageActionState extends RoutineActionState {}

class RoutineItemDeletedActionState extends RoutineActionState {}

class RoutineItemSelectedActionState extends RoutineActionState {}

class RoutineItemsDeletedActionState extends RoutineActionState {}
