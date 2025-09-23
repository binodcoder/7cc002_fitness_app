import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/model/routine_model.dart';

abstract class RoutineState extends Equatable {
  const RoutineState();

  @override
  List<Object> get props => [];
}

abstract class RoutineActionState extends RoutineState {}

class RoutineInitialState extends RoutineState {}

class RoutineLoadingState extends RoutineState {}

class RoutineLoadedSuccessState extends RoutineState {
  final List<RoutineModel> routineModelList;
  const RoutineLoadedSuccessState(this.routineModelList);
  RoutineLoadedSuccessState copyWith({List<RoutineModel>? routineModelList}) {
    return RoutineLoadedSuccessState(routineModelList ?? this.routineModelList);
  }
}

class RoutineErrorState extends RoutineState {
  final String message;

  const RoutineErrorState({required this.message});
}

class RoutineNavigateToAddRoutineActionState extends RoutineActionState {}

class RoutineNavigateToDetailPageActionState extends RoutineActionState {
  final RoutineModel routineModel;

  RoutineNavigateToDetailPageActionState(this.routineModel);
}

class RoutineNavigateToUpdatePageActionState extends RoutineActionState {
  final RoutineModel routineModel;

  RoutineNavigateToUpdatePageActionState(this.routineModel);
}

class RoutineItemDeletedActionState extends RoutineActionState {}

class RoutineItemSelectedActionState extends RoutineActionState {}

class RoutineItemsDeletedActionState extends RoutineActionState {}
