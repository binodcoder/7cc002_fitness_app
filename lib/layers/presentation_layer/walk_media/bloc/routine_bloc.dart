import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/presentation_layer/routine/bloc/routine_event.dart';
import 'package:fitness_app/layers/presentation_layer/routine/bloc/routine_state.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/routine.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
 import '../../../domain_layer/register/usecases/update_user.dart';
import '../../../domain_layer/routine/usecases/get_routines.dart';


class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutines getRoutines;
 // final UpdateRoutines updatePost;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<RoutineModel> selectedRoutines = [];
  RoutineBloc({
    required this.getRoutines,
  //  required this.updatePost,
  }) : super(RoutineInitialState()) {
    on<RoutineInitialEvent>(routineInitialEvent);
    on<PostEditButtonClickedEvent>(postEditButtonClickedEvent);
    on<PostDeleteButtonClickedEvent>(postDeleteButtonClickedEvent);
    on<PostDeleteAllButtonClickedEvent>(postDeleteAllButtonClickedEvent);
    on<PostAddButtonClickedEvent>(postAddButtonClickedEvent);
    on<RoutineTileNavigateEvent>(postTileNavigateEvent);
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

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<RoutineState> emit) {}

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<RoutineState> emit) async {
    await dbHelper.deletePost(event.routineModel.id);
    List<RoutineModel> routineList = await dbHelper.getRoutines();
    emit(RoutineLoadedSuccessState(routineList));
  }

  FutureOr<void> postDeleteAllButtonClickedEvent(PostDeleteAllButtonClickedEvent event, Emitter<RoutineState> emit) async {
    for (var element in selectedRoutines) {
      await dbHelper.deletePost(element.id);
    }
    List<RoutineModel> postList = await dbHelper.getRoutines();
    emit(RoutineLoadedSuccessState(postList));
  }

  FutureOr<void> postAddButtonClickedEvent(PostAddButtonClickedEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToAddPostActionState());
  }

  FutureOr<void> postTileNavigateEvent(RoutineTileNavigateEvent event, Emitter<RoutineState> emit) {
    emit(RoutineNavigateToDetailPageActionState(event.routineModel));
  }
}
