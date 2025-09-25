import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../domain/usecases/add_live_training.dart';
import '../../../domain/usecases/update_live_training.dart';
import 'live_training_add_event.dart';
import 'live_training_add_state.dart';

class LiveTrainingAddBloc
    extends Bloc<LiveTrainingAddEvent, LiveTrainingAddState> {
  final AddLiveTraining addLiveTraining;
  final UpdateLiveTraining updateLiveTraining;

  LiveTrainingAddBloc({
    required this.addLiveTraining,
    required this.updateLiveTraining,
  }) : super(const LiveTrainingAddInitialState()) {
    on<LiveTrainingAddInitialEvent>(liveTrainingAddInitialEvent);
    on<LiveTrainingAddReadyToUpdateEvent>(liveTrainingAddReadyToUpdateEvent);
    on<LiveTrainingAddSaveButtonPressEvent>(
        addLiveTrainingSaveButtonPressEvent);
    on<LiveTrainingAddUpdateButtonPressEvent>(
        liveTrainingAddUpdateButtonPressEvent);
  }

  FutureOr<void> addLiveTrainingSaveButtonPressEvent(
      LiveTrainingAddSaveButtonPressEvent event,
      Emitter<LiveTrainingAddState> emit) async {
    emit(const LiveTrainingAddLoadingState());
    final result = await addLiveTraining(event.liveTraining);
    result!.fold((failure) {
      emit(const AddLiveTrainingErrorState());
    }, (result) {
      emit(const AddLiveTrainingSavedState());
    });
  }

  FutureOr<void> liveTrainingAddInitialEvent(LiveTrainingAddInitialEvent event,
      Emitter<LiveTrainingAddState> emit) async {
    // emit(LiveTrainingAddLoadingState());
    // final syncResult = await sync("test@wlv.ac.uk");
    //
    // syncResult!.fold((failure) {
    //   // emit(Error(message: _mapFailureToMessage(failure)));
    // }, (syncData) {
    //   emit(LiveTrainingAddLoadedSuccessState(syncData));
    // });
  }

  FutureOr<void> liveTrainingAddUpdateButtonPressEvent(
      LiveTrainingAddUpdateButtonPressEvent event,
      Emitter<LiveTrainingAddState> emit) async {
    emit(const LiveTrainingAddLoadingState());
    final result = await updateLiveTraining(event.liveTraining);
    result!.fold((failure) {
      emit(const AddLiveTrainingErrorState());
    }, (result) {
      emit(const AddLiveTrainingUpdatedState());
    });
  }

  FutureOr<void> liveTrainingAddReadyToUpdateEvent(
      LiveTrainingAddReadyToUpdateEvent event,
      Emitter<LiveTrainingAddState> emit) {
    // emit(LiveTrainingAddReadyToUpdateState(event.LiveTrainingModel.imagePath));
  }
}
