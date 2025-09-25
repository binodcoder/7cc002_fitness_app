import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/shared/data/local/db_helper.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_live_training.dart';
import '../../../domain/usecases/get_live_trainings.dart';
import 'live_training_event.dart';
import 'live_training_state.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class LiveTrainingBloc extends Bloc<LiveTrainingEvent, LiveTrainingState> {
  final GetLiveTrainings getLiveTrainings;
  final DeleteLiveTraining deleteLiveTraining;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<LiveTraining> selectedLiveTrainings = [];
  LiveTrainingBloc({
    required this.getLiveTrainings,
    required this.deleteLiveTraining,
  }) : super(const LiveTrainingInitialState()) {
    on<LiveTrainingInitialEvent>(liveTrainingInitialEvent);
    on<LiveTrainingEditButtonClickedEvent>(liveTrainingEditButtonClickedEvent);
    on<LiveTrainingDeleteButtonClickedEvent>(
        liveTrainingDeleteButtonClickedEvent);
    on<LiveTrainingDeleteAllButtonClickedEvent>(
        liveTrainingDeleteAllButtonClickedEvent);
    on<LiveTrainingAddButtonClickedEvent>(liveTrainingAddButtonClickedEvent);
    on<LiveTrainingTileNavigateEvent>(liveTrainingTileNavigateEvent);
    on<LiveTrainingDaySelectEvent>(liveTrainingDaySelectEvent);
  }

  FutureOr<void> liveTrainingInitialEvent(
      LiveTrainingInitialEvent event, Emitter<LiveTrainingState> emit) async {
    emit(const LiveTrainingLoadingState());
    final liveTrainingsResult = await getLiveTrainings(NoParams());

    liveTrainingsResult!.fold((failure) {
      emit(LiveTrainingErrorState(message: mapFailureToMessage(failure)));
    }, (liveTrainings) {
      emit(LiveTrainingLoadedSuccessState(liveTrainings: liveTrainings));
    });
  }

  FutureOr<void> liveTrainingEditButtonClickedEvent(
      LiveTrainingEditButtonClickedEvent event,
      Emitter<LiveTrainingState> emit) {
    emit(LiveTrainingNavigateToUpdatePageActionState(
        liveTraining: event.liveTraining));
  }

  FutureOr<void> liveTrainingDeleteButtonClickedEvent(
      LiveTrainingDeleteButtonClickedEvent event,
      Emitter<LiveTrainingState> emit) async {
    final result = await deleteLiveTraining(event.liveTraining.trainerId);

    result!.fold((failure) {
      emit(LiveTrainingShowErrorActionState(
          message: mapFailureToMessage(failure)));
    }, (response) {
      emit(const LiveTrainingItemDeletedActionState());
    });

    // await dbHelper.deleteLiveTraining(event.LiveTrainingModel.id);
    // List<LiveTrainingModel> LiveTrainingList = await dbHelper.getLiveTrainings();
    // emit(LiveTrainingLoadedSuccessState(LiveTrainingList));
  }

  FutureOr<void> liveTrainingDeleteAllButtonClickedEvent(
      LiveTrainingDeleteAllButtonClickedEvent event,
      Emitter<LiveTrainingState> emit) async {
    // for (var element in selectedLiveTrainings) {
    //   await dbHelper.deleteLiveTraining(element.id);
    // }
    // List<LiveTrainingModel> LiveTrainingList = await dbHelper.getLiveTrainings();
    // emit(LiveTrainingLoadedSuccessState(LiveTrainingList));
  }

  FutureOr<void> liveTrainingAddButtonClickedEvent(
      LiveTrainingAddButtonClickedEvent event,
      Emitter<LiveTrainingState> emit) {
    emit(const LiveTrainingNavigateToAddLiveTrainingActionState());
  }

  FutureOr<void> liveTrainingTileNavigateEvent(
      LiveTrainingTileNavigateEvent event, Emitter<LiveTrainingState> emit) {
    emit(LiveTrainingNavigateToDetailPageActionState(
        liveTraining: event.liveTraining));
  }

  FutureOr<void> liveTrainingDaySelectEvent(
      LiveTrainingDaySelectEvent e, Emitter<LiveTrainingState> emit) {
    // emit(LiveTrainingLoadedSuccessState(e.LiveTrainingModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
    // emit(LiveTrainingDaySelectedState(e.liveTrainingModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
  }
}
