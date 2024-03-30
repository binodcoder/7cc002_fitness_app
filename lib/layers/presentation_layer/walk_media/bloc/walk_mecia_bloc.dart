import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/domain_layer/walk_media/usecases/delete_walk_media.dart';
import 'package:fitness_app/layers/presentation_layer/walk_media/bloc/walk_media_event.dart';
import 'package:fitness_app/layers/presentation_layer/walk_media/bloc/walk_media_event.dart';
import 'package:fitness_app/layers/presentation_layer/walk_media/bloc/walk_media_event.dart';
import 'package:fitness_app/layers/presentation_layer/walk_media/bloc/walk_media_event.dart';
import 'package:fitness_app/layers/presentation_layer/walk_media/bloc/walk_media_state.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/model/walk_media_model.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../domain_layer/register/usecases/update_user.dart';
import '../../../domain_layer/walk_media/usecases/get_walk_media.dart';

class WalkMediaBloc extends Bloc<WalkMediaEvent, WalkMediaState> {
  final GetWalkMedia getWalkMedia;
  final DeleteWalkMedia deleteWalkMedia;
  // final UpdateWalkMedias updateWalkMedia;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<WalkMediaModel> selectedWalkMedias = [];
  WalkMediaBloc({
    required this.getWalkMedia,
    required this.deleteWalkMedia,
    //  required this.updateWalkMedia,
  }) : super(WalkMediaInitialState()) {
    on<WalkMediaInitialEvent>(walkMediaInitialEvent);
    on<WalkMediaEditButtonClickedEvent>(walkMediaEditButtonClickedEvent);
    on<WalkMediaDeleteButtonClickedEvent>(walkMediaDeleteButtonClickedEvent);
    on<WalkMediaDeleteAllButtonClickedEvent>(walkMediaDeleteAllButtonClickedEvent);
    on<WalkMediaAddButtonClickedEvent>(walkMediaAddButtonClickedEvent);
    on<WalkMediaTileNavigateEvent>(walkMediaTileNavigateEvent);
  }

  FutureOr<void> walkMediaInitialEvent(WalkMediaInitialEvent event, Emitter<WalkMediaState> emit) async {
    emit(WalkMediaLoadingState());
    final walkMediaModelList = await getWalkMedia(NoParams());

    walkMediaModelList!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (walkMediaModelList) {
      emit(WalkMediaLoadedSuccessState(walkMediaModelList));
    });
  }

  FutureOr<void> walkMediaEditButtonClickedEvent(WalkMediaEditButtonClickedEvent event, Emitter<WalkMediaState> emit) {}

  FutureOr<void> walkMediaDeleteButtonClickedEvent(WalkMediaDeleteButtonClickedEvent event, Emitter<WalkMediaState> emit) async {
    // await dbHelper.deleteWalkMedia(event.walkMediaModel.id);
    // List<WalkMediaModel> walkMediaList = await dbHelper.getWalkMedias();
    // emit(WalkMediaLoadedSuccessState(walkMediaList));
  }

  FutureOr<void> walkMediaDeleteAllButtonClickedEvent(WalkMediaDeleteAllButtonClickedEvent event, Emitter<WalkMediaState> emit) async {
    // for (var element in selectedWalkMedias) {
    //   await dbHelper.deleteWalkMedia(element.id);
    // }
    // List<WalkMediaModel> walkMediaList = await dbHelper.getWalkMedias();
    // emit(WalkMediaLoadedSuccessState(walkMediaList));
  }

  FutureOr<void> walkMediaAddButtonClickedEvent(WalkMediaAddButtonClickedEvent event, Emitter<WalkMediaState> emit) {
    emit(WalkMediaNavigateToAddWalkMediaActionState());
  }

  FutureOr<void> walkMediaTileNavigateEvent(WalkMediaTileNavigateEvent event, Emitter<WalkMediaState> emit) {
    emit(WalkMediaNavigateToDetailPageActionState(event.walkMediaModel));
  }
}