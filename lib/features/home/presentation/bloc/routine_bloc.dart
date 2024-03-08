import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/entities/routine.dart';
import '../../../../core/model/routine_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../add_post/domain/usecases/update_post.dart';
import '../../domain/usecases/get_routines.dart';
import 'routine_event.dart';
import 'routine_state.dart';

class RoutineBloc extends Bloc<RoutineEvent, RoutineState> {
  final GetRoutines getRoutines;
  final UpdatePost updatePost;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Routine> selectedPosts = [];
  RoutineBloc({
    required this.getRoutines,
    required this.updatePost,
  }) : super(RoutineInitialState()) {
    on<RoutineInitialEvent>(postInitialEvent);
    on<PostEditButtonClickedEvent>(postEditButtonClickedEvent);
    on<PostDeleteButtonClickedEvent>(postDeleteButtonClickedEvent);
    on<PostDeleteAllButtonClickedEvent>(postDeleteAllButtonClickedEvent);
    on<PostAddButtonClickedEvent>(postAddButtonClickedEvent);
    on<RoutineTileNavigateEvent>(postTileNavigateEvent);
    on<RoutineTileLongPressEvent>(postTileLongPressEvent);
  }

  FutureOr<void> postInitialEvent(RoutineInitialEvent event, Emitter<RoutineState> emit) async {
    emit(RoutineLoadingState());
    final postModelList = await getRoutines(NoParams());

    postModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (postModelList) {
      for (var post in postModelList) {
        if (post.isSelected == 1) {
          selectedPosts.add(post);
        }
      }
      emit(RoutineLoadedSuccessState(postModelList));
    });
  }

  FutureOr<void> postEditButtonClickedEvent(PostEditButtonClickedEvent event, Emitter<RoutineState> emit) {}

  FutureOr<void> postDeleteButtonClickedEvent(PostDeleteButtonClickedEvent event, Emitter<RoutineState> emit) async {
    await dbHelper.deletePost(event.postModel.id);
    List<RoutineModel> postList = await dbHelper.getRoutines();
    emit(RoutineLoadedSuccessState(postList));
  }

  FutureOr<void> postDeleteAllButtonClickedEvent(PostDeleteAllButtonClickedEvent event, Emitter<RoutineState> emit) async {
    for (var element in selectedPosts) {
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

  FutureOr<void> postTileLongPressEvent(RoutineTileLongPressEvent event, Emitter<RoutineState> emit) async {
    var updatedPost = event.routineModel;
    if (updatedPost.isSelected == 0) {
      updatedPost.isSelected = 1;
      selectedPosts.add(updatedPost);
    } else {
      updatedPost.isSelected = 0;
      selectedPosts.remove(updatedPost);
    }
    await updatePost(updatedPost);
    final postList = await getRoutines(NoParams());
    postList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (post) {
      emit(RoutineLoadedSuccessState(post));
    });
  }
}
