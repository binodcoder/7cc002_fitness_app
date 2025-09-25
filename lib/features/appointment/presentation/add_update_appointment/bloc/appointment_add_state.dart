import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AppointmentAddState extends Equatable {
  const AppointmentAddState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class AppointmentAddActionState extends AppointmentAddState {
  const AppointmentAddActionState();
}

class AppointmentAddLoadingState extends AppointmentAddState {
  const AppointmentAddLoadingState();
}

class AppointmentAddLoadedSuccessState extends AppointmentAddState {
  final SyncModel syncModel;
  const AppointmentAddLoadedSuccessState({required this.syncModel});
  AppointmentAddLoadedSuccessState copyWith({SyncModel? syncModel}) {
    return AppointmentAddLoadedSuccessState(syncModel: syncModel ?? this.syncModel);
  }

  @override
  List<Object?> get props => [syncModel];
}

class AppointmentAddInitialState extends AppointmentAddState {
  const AppointmentAddInitialState();
}

class AppointmentAddReadyToUpdateState extends AppointmentAddState {
  const AppointmentAddReadyToUpdateState();
}

class AddAppointmentSavedState extends AppointmentAddActionState {
  const AddAppointmentSavedState();
}

class AddAppointmentUpdatedState extends AppointmentAddActionState {
  const AddAppointmentUpdatedState();
}

class AddAppointmentErrorState extends AppointmentAddActionState {
  final String message;
  const AddAppointmentErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
