import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_event.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/bloc/routine_state.dart';
import 'package:fitness_app/shared/data/local/db_helper.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_routine.dart';
import '../../../domain/usecases/get_routines.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutines getRoutines;
  final DeleteRoutine deleteRoutine;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Routine> selectedRoutines = [];

  RoutineState get initialState => const RoutineInitialState();

  RoutineBloc({
    required this.getRoutines,
    required this.deleteRoutine,
  }) : super(const RoutineInitialState()) {
    on<RoutineInitialEvent>(routineInitialEvent);
    on<RoutineEditButtonClickedEvent>(routineEditButtonClickedEvent);
    on<RoutineDeleteButtonClickedEvent>(routineDeleteButtonClickedEvent);
    on<RoutineDeleteAllButtonClickedEvent>(routineDeleteAllButtonClickedEvent);
    on<RoutineAddButtonClickedEvent>(routineAddButtonClickedEvent);
    on<RoutineTileNavigateEvent>(routineTileNavigateEvent);
  }

  FutureOr<void> routineInitialEvent(
      RoutineInitialEvent event, Emitter<RoutineState> emit) async {
    emit(const RoutineLoadingState());
    final routineList = await getRoutines(NoParams());

    routineList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (routines) {
      emit(RoutineLoadedSuccessState(routines));
    });
  }

  FutureOr<void> routineEditButtonClickedEvent(
      RoutineEditButtonClickedEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToUpdatePageActionState(event.routine));
  }

  FutureOr<void> routineDeleteButtonClickedEvent(
      RoutineDeleteButtonClickedEvent event, Emitter<RoutineState> emit) async {
    // await dbHelper.deleteRoutine(event.routine.id);
    // List<RoutineModel> routineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(routineList));
  }

  FutureOr<void> routineDeleteAllButtonClickedEvent(
      RoutineDeleteAllButtonClickedEvent event,
      Emitter<RoutineState> emit) async {
    // for (var element in selectedRoutines) {
    //   await dbHelper.deleteRoutine(element.id);
    // }
    // List<RoutineModel> RoutineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(RoutineList));
  }

  FutureOr<void> routineAddButtonClickedEvent(
      RoutineAddButtonClickedEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToAddRoutineActionState());
  }

  FutureOr<void> routineTileNavigateEvent(
      RoutineTileNavigateEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToDetailPageActionState(event.routine));
  }
}
