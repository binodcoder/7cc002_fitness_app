import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/walk_media/presentation/get_walk_media/bloc/walk_media_event.dart';
import 'package:fitness_app/features/walk_media/presentation/get_walk_media/bloc/walk_media_state.dart';
import 'package:fitness_app/shared/data/local/db_helper.dart';
import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';
import '../../../domain/usecases/delete_walk_media.dart';
import '../../../domain/usecases/get_walk_media.dart';
import '../../../domain/usecases/get_walk_media_by_walk_id.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class WalkMediaBloc extends Bloc<WalkMediaEvent, WalkMediaState> {
  final GetWalkMedia getWalkMedia;
  final DeleteWalkMedia deleteWalkMedia;
  final GetWalkMediaByWalkId getWalkMediaByWalkId;
  // final UpdateWalkMedias updateWalkMedia;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<WalkMedia> selectedWalkMedias = [];
  WalkMediaBloc({
    required this.getWalkMedia,
    required this.deleteWalkMedia,
    required this.getWalkMediaByWalkId,
    //  required this.updateWalkMedia,
  }) : super(const WalkMediaInitialState()) {
    on<WalkMediaInitialEvent>(walkMediaInitialEvent);
    on<WalkMediaEditButtonClickedEvent>(walkMediaEditButtonClickedEvent);
    on<WalkMediaDeleteButtonClickedEvent>(walkMediaDeleteButtonClickedEvent);
    on<WalkMediaDeleteAllButtonClickedEvent>(
        walkMediaDeleteAllButtonClickedEvent);
    on<WalkMediaAddButtonClickedEvent>(walkMediaAddButtonClickedEvent);
    on<WalkMediaTileNavigateEvent>(walkMediaTileNavigateEvent);
  }

  FutureOr<void> walkMediaInitialEvent(
      WalkMediaInitialEvent event, Emitter<WalkMediaState> emit) async {
    emit(const WalkMediaLoadingState());
    final walkMediaListResult = await getWalkMediaByWalkId(event.walkId);

    walkMediaListResult!.fold((failure) {
      emit(WalkMediaErrorState(message: mapFailureToMessage(failure)));
    }, (walkMediaList) {
      emit(WalkMediaLoadedSuccessState(walkMediaList));
    });
  }

  FutureOr<void> walkMediaEditButtonClickedEvent(
      WalkMediaEditButtonClickedEvent event, Emitter<WalkMediaState> emit) {
    emit(WalkMediaNavigateToUpdatePageActionState(event.walkMedia));
  }

  FutureOr<void> walkMediaDeleteButtonClickedEvent(
      WalkMediaDeleteButtonClickedEvent event,
      Emitter<WalkMediaState> emit) async {
    final result = await deleteWalkMedia(event.walkMedia.id!);

    result!.fold((failure) {
      emit(WalkMediaShowErrorActionState(
          message: mapFailureToMessage(failure)));
    }, (response) {
      emit(const WalkMediaItemDeletedActionState());
    });
  }

  FutureOr<void> walkMediaDeleteAllButtonClickedEvent(
      WalkMediaDeleteAllButtonClickedEvent event,
      Emitter<WalkMediaState> emit) async {
    // for (var element in selectedWalkMedias) {
    //   await dbHelper.deleteWalkMedia(element.id);
    // }
    // List<WalkMediaModel> walkMediaList = await dbHelper.getWalkMedias();
    // emit(WalkMediaLoadedSuccessState(walkMediaList));
  }

  FutureOr<void> walkMediaAddButtonClickedEvent(
      WalkMediaAddButtonClickedEvent event, Emitter<WalkMediaState> emit) {
    emit(WalkMediaNavigateToAddWalkMediaActionState(event.walkId));
  }

  FutureOr<void> walkMediaTileNavigateEvent(
      WalkMediaTileNavigateEvent event, Emitter<WalkMediaState> emit) {
    emit(WalkMediaNavigateToDetailPageActionState(event.walkMedia));
  }
}
