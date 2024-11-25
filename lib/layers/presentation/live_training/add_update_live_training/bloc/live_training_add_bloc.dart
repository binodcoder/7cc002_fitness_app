import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../domain/live_training/usecases/add_live_training.dart';
import '../../../../domain/live_training/usecases/update_live_training.dart';
import 'live_training_add_event.dart';
import 'live_training_add_state.dart';

class LiveTrainingAddBloc extends Bloc<LiveTrainingAddEvent, LiveTrainingAddState> {
  final AddLiveTraining addLiveTraining;
  final UpdateLiveTraining updateLiveTraining;

  LiveTrainingAddBloc({
    required this.addLiveTraining,
    required this.updateLiveTraining,
  }) : super(LiveTrainingAddInitialState()) {
    on<LiveTrainingAddInitialEvent>(liveTrainingAddInitialEvent);
    on<LiveTrainingAddReadyToUpdateEvent>(liveTrainingAddReadyToUpdateEvent);
    on<LiveTrainingAddSaveButtonPressEvent>(addLiveTrainingSaveButtonPressEvent);
    on<LiveTrainingAddUpdateButtonPressEvent>(liveTrainingAddUpdateButtonPressEvent);
  }

  FutureOr<void> addLiveTrainingSaveButtonPressEvent(LiveTrainingAddSaveButtonPressEvent event, Emitter<LiveTrainingAddState> emit) async {
    emit(LiveTrainingAddLoadingState());
    final result = await addLiveTraining(event.liveTrainingModel);
    result!.fold((failure) {
      emit(AddLiveTrainingErrorState());
    }, (result) {
      emit(AddLiveTrainingSavedState());
    });
  }

  FutureOr<void> liveTrainingAddInitialEvent(LiveTrainingAddInitialEvent event, Emitter<LiveTrainingAddState> emit) async {
    // emit(LiveTrainingAddLoadingState());
    // final syncResult = await sync("test@wlv.ac.uk");
    //
    // syncResult!.fold((failure) {
    //   // emit(Error(message: _mapFailureToMessage(failure)));
    // }, (syncData) {
    //   emit(LiveTrainingAddLoadedSuccessState(syncData));
    // });
  }

  FutureOr<void> liveTrainingAddUpdateButtonPressEvent(LiveTrainingAddUpdateButtonPressEvent event, Emitter<LiveTrainingAddState> emit) async {
    emit(LiveTrainingAddLoadingState());
    final result = await updateLiveTraining(event.liveTrainingModel);
    result!.fold((failure) {
      emit(AddLiveTrainingErrorState());
    }, (result) {
      emit(AddLiveTrainingUpdatedState());
    });
  }

  FutureOr<void> liveTrainingAddReadyToUpdateEvent(LiveTrainingAddReadyToUpdateEvent event, Emitter<LiveTrainingAddState> emit) {
    // emit(LiveTrainingAddReadyToUpdateState(event.LiveTrainingModel.imagePath));
  }
}
