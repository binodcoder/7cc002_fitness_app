import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_event.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_list_state.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_routine.dart';
import '../../../domain/usecases/get_routines.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class RoutineListBloc extends Bloc<RoutineListEvent, RoutineListState> {
  final GetRoutines getRoutines;
  final DeleteRoutine deleteRoutine;
  List<Routine> selectedRoutines = [];

  RoutineListState get initialState => const RoutineListInitialState();

  RoutineListBloc({
    required this.getRoutines,
    required this.deleteRoutine,
  }) : super(const RoutineListInitialState()) {
    on<RoutineListInitialEvent>(routineInitialEvent);
    on<RoutineListEditButtonClickedEvent>(routineEditButtonClickedEvent);
    on<RoutineListDeleteButtonClickedEvent>(routineDeleteButtonClickedEvent);
    on<RoutineListDeleteAllButtonClickedEvent>(
        routineDeleteAllButtonClickedEvent);
    on<RoutineListAddButtonClickedEvent>(routineAddButtonClickedEvent);
    on<RoutineListTileNavigateEvent>(routineTileNavigateEvent);
  }

  FutureOr<void> routineInitialEvent(
      RoutineListInitialEvent event, Emitter<RoutineListState> emit) async {
    emit(const RoutineListLoadingState());
    final routineList = await getRoutines(NoParams());
    routineList!.fold(
      (failure) =>
          emit(RoutineListErrorState(message: mapFailureToMessage(failure))),
      (routines) => emit(RoutineListLoadedSuccessState(routines)),
    );
  }

  FutureOr<void> routineEditButtonClickedEvent(
      RoutineListEditButtonClickedEvent event, Emitter<RoutineListState> emit) {
    emit(RoutineListNavigateToUpdatePageActionState(event.routine));
  }

  FutureOr<void> routineDeleteButtonClickedEvent(
      RoutineListDeleteButtonClickedEvent event,
      Emitter<RoutineListState> emit) async {
    // await dbHelper.deleteRoutine(event.routine.id);
    // List<RoutineModel> routineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(routineList));
  }

  FutureOr<void> routineDeleteAllButtonClickedEvent(
      RoutineListDeleteAllButtonClickedEvent event,
      Emitter<RoutineListState> emit) async {
    // for (var element in selectedRoutines) {
    //   await dbHelper.deleteRoutine(element.id);
    // }
    // List<RoutineModel> RoutineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(RoutineList));
  }

  FutureOr<void> routineAddButtonClickedEvent(
      RoutineListAddButtonClickedEvent event, Emitter<RoutineListState> emit) {
    emit(RoutineListNavigateToAddRoutineActionState());
  }

  FutureOr<void> routineTileNavigateEvent(
      RoutineListTileNavigateEvent event, Emitter<RoutineListState> emit) {
    emit(RoutineListNavigateToDetailPageActionState(event.routine));
  }
}
