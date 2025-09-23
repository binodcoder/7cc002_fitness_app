import 'package:fitness_app/core/model/sync_data_model.dart';

abstract class AppointmentAddState {}

abstract class AppointmentAddActionState extends AppointmentAddState {}

class AppointmentAddLoadingState extends AppointmentAddState {}

class AppointmentAddLoadedSuccessState extends AppointmentAddState {
  final SyncModel syncModel;
  AppointmentAddLoadedSuccessState(this.syncModel);
  AppointmentAddLoadedSuccessState copyWith({SyncModel? syncModel}) {
    return AppointmentAddLoadedSuccessState(syncModel ?? this.syncModel);
  }
}

class AppointmentAddInitialState extends AppointmentAddState {}

class AppointmentAddReadyToUpdateState extends AppointmentAddState {}

class AddAppointmentSavedState extends AppointmentAddActionState {}

class AddAppointmentUpdatedState extends AppointmentAddActionState {}

class AddAppointmentErrorState extends AppointmentAddActionState {
  final String message;
  AddAppointmentErrorState({required this.message});
}
