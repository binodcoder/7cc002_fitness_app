import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

abstract class RoutineState extends Equatable {
  const RoutineState();

  @override
  List<Object> get props => [];
}

abstract class RoutineActionState extends RoutineState {}

class RoutineInitialState extends RoutineState {
  const RoutineInitialState();
}

class RoutineLoadingState extends RoutineState {
  const RoutineLoadingState();
}

class RoutineLoadedSuccessState extends RoutineState {
  final List<Routine> routines;
  const RoutineLoadedSuccessState(this.routines);
  RoutineLoadedSuccessState copyWith({List<Routine>? routines}) {
    return RoutineLoadedSuccessState(routines ?? this.routines);
  }
}

class RoutineErrorState extends RoutineState {
  final String message;

  const RoutineErrorState({required this.message});
}

class RoutineNavigateToAddRoutineActionState extends RoutineActionState {}

class RoutineNavigateToDetailPageActionState extends RoutineActionState {
  final Routine routine;

  RoutineNavigateToDetailPageActionState(this.routine);
}

class RoutineNavigateToUpdatePageActionState extends RoutineActionState {
  final Routine routine;

  RoutineNavigateToUpdatePageActionState(this.routine);
}

class RoutineItemDeletedActionState extends RoutineActionState {}

class RoutineItemSelectedActionState extends RoutineActionState {}

class RoutineItemsDeletedActionState extends RoutineActionState {}
