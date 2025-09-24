import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/walk/domain/usecases/leave_walk.dart';
import 'package:fitness_app/features/walk/presentation/walk/get_walks/bloc/walk_event.dart';
import 'package:fitness_app/features/walk/presentation/walk/get_walks/bloc/walk_state.dart';
import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walks.dart';
import 'package:fitness_app/features/walk/domain/usecases/join_walk.dart';

class WalkBloc extends Bloc<WalkEvent, WalkState> {
  final GetWalks getWalks;
  final DeleteWalk deleteWalk;
  final JoinWalk joinWalk;
  final LeaveWalk leaveWalk;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Walk> selectedWalks = [];
  WalkBloc({
    required this.getWalks,
    required this.deleteWalk,
    required this.joinWalk,
    required this.leaveWalk,
  }) : super(WalkInitialState()) {
    on<WalkInitialEvent>(walkInitialEvent);
    on<WalkEditButtonClickedEvent>(walkEditButtonClickedEvent);
    on<WalkDeleteButtonClickedEvent>(walkDeleteButtonClickedEvent);
    on<WalkDeleteAllButtonClickedEvent>(walkDeleteAllButtonClickedEvent);
    on<WalkAddButtonClickedEvent>(walkAddButtonClickedEvent);
    on<WalkTileNavigateEvent>(walkTileNavigateEvent);
    on<WalkJoinButtonClickedEvent>(walkJoinButtonClickedEvent);
    on<WalkLeaveButtonClickedEvent>(walkLeaveButtonClickedEvent);
  }

  FutureOr<void> walkInitialEvent(
      WalkInitialEvent event, Emitter<WalkState> emit) async {
    emit(WalkLoadingState());
    final walkListResult = await getWalks(NoParams());

    walkListResult!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (walks) {
      emit(WalkLoadedSuccessState(walks));
    });
  }

  FutureOr<void> walkEditButtonClickedEvent(
      WalkEditButtonClickedEvent event, Emitter<WalkState> emit) {
    emit(WalkNavigateToUpdatePageActionState(event.walk));
  }

  FutureOr<void> walkDeleteButtonClickedEvent(
      WalkDeleteButtonClickedEvent event, Emitter<WalkState> emit) async {}

  FutureOr<void> walkDeleteAllButtonClickedEvent(
      WalkDeleteAllButtonClickedEvent event, Emitter<WalkState> emit) async {}

  FutureOr<void> walkAddButtonClickedEvent(
      WalkAddButtonClickedEvent event, Emitter<WalkState> emit) {
    emit(WalkNavigateToAddWalkActionState());
  }

  FutureOr<void> walkTileNavigateEvent(
      WalkTileNavigateEvent event, Emitter<WalkState> emit) {
    emit(WalkNavigateToDetailPageActionState(event.walk));
  }

  FutureOr<void> walkJoinButtonClickedEvent(
      WalkJoinButtonClickedEvent event, Emitter<WalkState> emit) async {
    final result = await joinWalk(event.walkParticipant);

    result!.fold((failure) {
      emit(WalkErrorState());
    }, (result) {
      emit(WalkJoinedActionState());
    });
  }

  FutureOr<void> walkLeaveButtonClickedEvent(
      WalkLeaveButtonClickedEvent event, Emitter<WalkState> emit) async {
    final result = await leaveWalk(event.walkParticipant);

    result!.fold((failure) {
      emit(WalkErrorState());
    }, (result) {
      emit(WalkLeftActionState());
    });
  }
}
