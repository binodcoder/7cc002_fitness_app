import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/walk/domain/usecases/leave_walk.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_event.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/bloc/walk_list_state.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import 'package:fitness_app/features/walk/domain/usecases/delete_walk.dart';
import 'package:fitness_app/features/walk/domain/usecases/get_walks.dart';
import 'package:fitness_app/features/walk/domain/usecases/join_walk.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class WalkListBloc extends Bloc<WalkListEvent, WalkListState> {
  final GetWalks getWalks;
  final DeleteWalk deleteWalk;
  final JoinWalk joinWalk;
  final LeaveWalk leaveWalk;
  List<Walk> selectedWalks = [];
  WalkListBloc({
    required this.getWalks,
    required this.deleteWalk,
    required this.joinWalk,
    required this.leaveWalk,
  }) : super(const WalkListInitial()) {
    on<WalkListInitialized>(walkListInitialized);
    on<WalkEditRequested>(walkEditRequested);
    on<WalkDeleteRequested>(walkDeleteRequested);
    on<WalkDeleteAllRequested>(walkDeleteAllRequested);
    on<WalkDetailsRequested>(walkDetailsRequested);
    on<WalkJoinRequested>(walkJoinRequested);
    on<WalkLeaveRequested>(walkLeaveRequested);
  }

  FutureOr<void> walkListInitialized(
      WalkListInitialized event, Emitter<WalkListState> emit) async {
    emit(const WalkListLoading());
    final walkListResult = await getWalks(NoParams());

    walkListResult!.fold((failure) {
      emit(WalkListError(message: mapFailureToMessage(failure)));
    }, (walks) {
      emit(WalkListLoaded(walks: walks));
    });
  }

  FutureOr<void> walkEditRequested(
      WalkEditRequested event, Emitter<WalkListState> emit) {
    emit(WalkNavigateToEditActionState(walk: event.walk));
  }

  FutureOr<void> walkDeleteRequested(
      WalkDeleteRequested event, Emitter<WalkListState> emit) async {
    final id = event.walk.id;
    if (id == null) return;
    final res = await deleteWalk(id);
    await res?.fold((failure) async {
      emit(WalkListShowErrorActionState(message: mapFailureToMessage(failure)));
    }, (ok) async {
      final walkListResult = await getWalks(NoParams());
      walkListResult!.fold((failure) {
        emit(WalkListError(message: mapFailureToMessage(failure)));
      }, (walks) {
        emit(WalkListLoaded(walks: walks));
      });
    });
  }

  FutureOr<void> walkDeleteAllRequested(
      WalkDeleteAllRequested event, Emitter<WalkListState> emit) async {}

  FutureOr<void> walkDetailsRequested(
      WalkDetailsRequested event, Emitter<WalkListState> emit) {
    emit(WalkNavigateToDetailsActionState(walk: event.walk));
  }

  FutureOr<void> walkJoinRequested(
      WalkJoinRequested event, Emitter<WalkListState> emit) async {
    final result = await joinWalk(event.walkParticipant);

    result!.fold((failure) {
      emit(WalkListShowErrorActionState(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(const WalkJoinedActionState());
    });
  }

  FutureOr<void> walkLeaveRequested(
      WalkLeaveRequested event, Emitter<WalkListState> emit) async {
    final result = await leaveWalk(event.walkParticipant);

    result!.fold((failure) {
      emit(WalkListShowErrorActionState(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(const WalkLeftActionState());
    });
  }
}
