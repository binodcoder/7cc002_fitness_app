import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../core/model/live_training_model.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../domain/live_training/usecases/delete_live_training.dart';
import '../../../../domain/live_training/usecases/get_live_trainings.dart';
import 'live_training_event.dart';
import 'live_training_state.dart';

class LiveTrainingBloc extends Bloc<LiveTrainingEvent, LiveTrainingState> {
  final GetLiveTrainings getLiveTrainings;
  final DeleteLiveTraining deleteLiveTraining;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<LiveTrainingModel> selectedLiveTrainings = [];
  LiveTrainingBloc({
    required this.getLiveTrainings,
    required this.deleteLiveTraining,
  }) : super(LiveTrainingInitialState()) {
    on<LiveTrainingInitialEvent>(liveTrainingInitialEvent);
    on<LiveTrainingEditButtonClickedEvent>(liveTrainingEditButtonClickedEvent);
    on<LiveTrainingDeleteButtonClickedEvent>(liveTrainingDeleteButtonClickedEvent);
    on<LiveTrainingDeleteAllButtonClickedEvent>(liveTrainingDeleteAllButtonClickedEvent);
    on<LiveTrainingAddButtonClickedEvent>(liveTrainingAddButtonClickedEvent);
    on<LiveTrainingTileNavigateEvent>(liveTrainingTileNavigateEvent);
    on<LiveTrainingDaySelectEvent>(liveTrainingDaySelectEvent);
  }

  FutureOr<void> liveTrainingInitialEvent(LiveTrainingInitialEvent event, Emitter<LiveTrainingState> emit) async {
    emit(LiveTrainingLoadingState());
    final liveTrainings = await getLiveTrainings(NoParams());

    liveTrainings!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (liveTrainings) {
      emit(LiveTrainingLoadedSuccessState(liveTrainings));
    });
  }

  FutureOr<void> liveTrainingEditButtonClickedEvent(LiveTrainingEditButtonClickedEvent event, Emitter<LiveTrainingState> emit) {
    emit(LiveTrainingNavigateToUpdatePageActionState(event.liveTrainingModel));
  }

  FutureOr<void> liveTrainingDeleteButtonClickedEvent(LiveTrainingDeleteButtonClickedEvent event, Emitter<LiveTrainingState> emit) async {
    emit(LiveTrainingLoadingState());
    final result = await deleteLiveTraining(event.liveTrainingModel.trainerId);

    result!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (response) {
      emit(LiveTrainingItemDeletedActionState());
    });

    // await dbHelper.deleteLiveTraining(event.LiveTrainingModel.id);
    // List<LiveTrainingModel> LiveTrainingList = await dbHelper.getLiveTrainings();
    // emit(LiveTrainingLoadedSuccessState(LiveTrainingList));
  }

  FutureOr<void> liveTrainingDeleteAllButtonClickedEvent(LiveTrainingDeleteAllButtonClickedEvent event, Emitter<LiveTrainingState> emit) async {
    // for (var element in selectedLiveTrainings) {
    //   await dbHelper.deleteLiveTraining(element.id);
    // }
    // List<LiveTrainingModel> LiveTrainingList = await dbHelper.getLiveTrainings();
    // emit(LiveTrainingLoadedSuccessState(LiveTrainingList));
  }

  FutureOr<void> liveTrainingAddButtonClickedEvent(LiveTrainingAddButtonClickedEvent event, Emitter<LiveTrainingState> emit) {
    emit(LiveTrainingNavigateToAddLiveTrainingActionState());
  }

  FutureOr<void> liveTrainingTileNavigateEvent(LiveTrainingTileNavigateEvent event, Emitter<LiveTrainingState> emit) {
    emit(LiveTrainingNavigateToDetailPageActionState(event.liveTrainingModel));
  }

  FutureOr<void> liveTrainingDaySelectEvent(LiveTrainingDaySelectEvent e, Emitter<LiveTrainingState> emit) {
    // emit(LiveTrainingLoadedSuccessState(e.LiveTrainingModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
    // emit(LiveTrainingDaySelectedState(e.liveTrainingModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
  }
}
