import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/presentation/routine/get_routines/bloc/routine_event.dart';
import 'package:fitness_app/layers/presentation/routine/get_routines/bloc/routine_state.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../core/model/routine_model.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../domain/routine/usecases/delete_routine.dart';
import '../../../../domain/routine/usecases/get_routines.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutines getRoutines;
  final DeleteRoutine deleteRoutine;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<RoutineModel> selectedRoutines = [];

  RoutineState get initialState => RoutineInitialState();

  RoutineBloc({
    required this.getRoutines,
    required this.deleteRoutine,
  }) : super(RoutineInitialState()) {
    on<RoutineInitialEvent>(routineInitialEvent);
    on<RoutineEditButtonClickedEvent>(routineEditButtonClickedEvent);
    on<RoutineDeleteButtonClickedEvent>(routineDeleteButtonClickedEvent);
    on<RoutineDeleteAllButtonClickedEvent>(routineDeleteAllButtonClickedEvent);
    on<RoutineAddButtonClickedEvent>(routineAddButtonClickedEvent);
    on<RoutineTileNavigateEvent>(routineTileNavigateEvent);
  }

  FutureOr<void> routineInitialEvent(RoutineInitialEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    final routineModelList = await getRoutines(NoParams());

    routineModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (routineModelList) {
      emit(RoutineLoadedSuccessState(routineModelList));
    });
  }

  FutureOr<void> routineEditButtonClickedEvent(RoutineEditButtonClickedEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToUpdatePageActionState(event.routineModel));
  }

  FutureOr<void> routineDeleteButtonClickedEvent(RoutineDeleteButtonClickedEvent event, Emitter<RoutineState> emit) async {
    // await dbHelper.deleteRoutine(event.routineModel.id);
    // List<RoutineModel> routineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(routineList));
  }

  FutureOr<void> routineDeleteAllButtonClickedEvent(RoutineDeleteAllButtonClickedEvent event, Emitter<RoutineState> emit) async {
    // for (var element in selectedRoutines) {
    //   await dbHelper.deleteRoutine(element.id);
    // }
    // List<RoutineModel> RoutineList = await dbHelper.getRoutines();
    // emit(RoutineLoadedSuccessState(RoutineList));
  }

  FutureOr<void> routineAddButtonClickedEvent(RoutineAddButtonClickedEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToAddRoutineActionState());
  }

  FutureOr<void> routineTileNavigateEvent(RoutineTileNavigateEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToDetailPageActionState(event.routineModel));
  }
}
