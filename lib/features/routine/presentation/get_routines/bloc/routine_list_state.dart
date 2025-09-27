import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

abstract class RoutineListState extends Equatable {
  const RoutineListState();

  @override
  List<Object> get props => [];
}

abstract class RoutineListActionState extends RoutineListState {}

class RoutineListInitialState extends RoutineListState {
  const RoutineListInitialState();
}

class RoutineListLoadingState extends RoutineListState {
  const RoutineListLoadingState();
}

class RoutineListLoadedSuccessState extends RoutineListState {
  final List<Routine> routines;
  const RoutineListLoadedSuccessState(this.routines);
  RoutineListLoadedSuccessState copyWith({List<Routine>? routines}) {
    return RoutineListLoadedSuccessState(routines ?? this.routines);
  }
}

class RoutineListErrorState extends RoutineListState {
  final String message;

  const RoutineListErrorState({required this.message});
}

class RoutineListNavigateToAddRoutineActionState extends RoutineListActionState {}

class RoutineListNavigateToDetailPageActionState extends RoutineListActionState {
  final Routine routine;

  RoutineListNavigateToDetailPageActionState(this.routine);
}

class RoutineListNavigateToUpdatePageActionState extends RoutineListActionState {
  final Routine routine;

  RoutineListNavigateToUpdatePageActionState(this.routine);
}

class RoutineListItemDeletedActionState extends RoutineListActionState {}

class RoutineListItemSelectedActionState extends RoutineListActionState {}

class RoutineListItemsDeletedActionState extends RoutineListActionState {}
