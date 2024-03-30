import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/domain_layer/walk/usecases/delete_walk.dart';
import 'package:fitness_app/layers/presentation_layer/walk/get_walks/bloc/walk_event.dart';
import 'package:fitness_app/layers/presentation_layer/walk/get_walks/bloc/walk_state.dart';

import '../../../../../core/db/db_helper.dart';
import '../../../../../core/model/Walk_model.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../domain_layer/register/usecases/update_user.dart';
import '../../../../domain_layer/walk/usecases/get_walks.dart';

class WalkBloc extends Bloc<WalkEvent, WalkState> {
  final GetWalks getWalks;
  final DeleteWalk deleteWalk;
  // final UpdateWalks updateWalk;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<WalkModel> selectedWalks = [];
  WalkBloc({
    required this.getWalks,
    required this.deleteWalk,
    //  required this.updateWalk,
  }) : super(WalkInitialState()) {
    on<WalkInitialEvent>(walkInitialEvent);
    on<WalkEditButtonClickedEvent>(walkEditButtonClickedEvent);
    on<WalkDeleteButtonClickedEvent>(walkDeleteButtonClickedEvent);
    on<WalkDeleteAllButtonClickedEvent>(walkDeleteAllButtonClickedEvent);
    on<WalkAddButtonClickedEvent>(walkAddButtonClickedEvent);
    on<WalkTileNavigateEvent>(walkTileNavigateEvent);
  }

  FutureOr<void> walkInitialEvent(WalkInitialEvent event, Emitter<WalkState> emit) async {
    emit(WalkLoadingState());
    final walkModelList = await getWalks(NoParams());

    walkModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (walkModelList) {
      emit(WalkLoadedSuccessState(walkModelList));
    });
  }

  FutureOr<void> walkEditButtonClickedEvent(WalkEditButtonClickedEvent event, Emitter<WalkState> emit) {}

  FutureOr<void> walkDeleteButtonClickedEvent(WalkDeleteButtonClickedEvent event, Emitter<WalkState> emit) async {
    //await dbHelper.deleteWalk(event.walkModel.id);
    // List<WalkModel> walkList = await  deleteWalk();
    // emit(WalkLoadedSuccessState(walkList));
  }

  FutureOr<void> walkDeleteAllButtonClickedEvent(WalkDeleteAllButtonClickedEvent event, Emitter<WalkState> emit) async {
    for (var element in selectedWalks) {
      // await dbHelper.deleteWalk(element.id);
    }
    // List<WalkModel> walkList = await dbHelper.getWalks();
    // emit(WalkLoadedSuccessState(walkList));
  }

  FutureOr<void> walkAddButtonClickedEvent(WalkAddButtonClickedEvent event, Emitter<WalkState> emit) {
    emit(WalkNavigateToAddWalkActionState());
  }

  FutureOr<void> walkTileNavigateEvent(WalkTileNavigateEvent event, Emitter<WalkState> emit) {
    emit(WalkNavigateToDetailPageActionState(event.walkModel));
  }
}
