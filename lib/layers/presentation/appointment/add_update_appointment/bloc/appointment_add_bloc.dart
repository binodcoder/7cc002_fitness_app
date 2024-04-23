import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../../core/mappers/map_failure_to_message.dart';
import '../../../../domain/appointment/usecases/add_appointment.dart';
import '../../../../domain/appointment/usecases/sync.dart';
import '../../../../domain/appointment/usecases/update_appointment.dart';
import 'appointment_add_event.dart';
import 'appointment_add_state.dart';

class AppointmentAddBloc extends Bloc<AppointmentAddEvent, AppointmentAddState> {
  final AddAppointment addAppointment;
  final UpdateAppointment updateAppointment;
  final Sync sync;
  final DatabaseHelper dbHelper = DatabaseHelper();
  AppointmentAddBloc({
    required this.addAppointment,
    required this.updateAppointment,
    required this.sync,
  }) : super(AppointmentAddInitialState()) {
    on<AppointmentAddInitialEvent>(appointmentAddInitialEvent);
    on<AppointmentAddReadyToUpdateEvent>(appointmentAddReadyToUpdateEvent);
    on<AppointmentAddSaveButtonPressEvent>(addAppointmentSaveButtonPressEvent);
    on<AppointmentAddUpdateButtonPressEvent>(appointmentAddUpdateButtonPressEvent);
  }

  FutureOr<void> addAppointmentSaveButtonPressEvent(AppointmentAddSaveButtonPressEvent event, Emitter<AppointmentAddState> emit) async {
    final result = await addAppointment(event.appointmentModel);
    result!.fold((failure) {
      emit(AddAppointmentErrorState(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(AddAppointmentSavedState());
    });
  }

  FutureOr<void> appointmentAddInitialEvent(AppointmentAddInitialEvent event, Emitter<AppointmentAddState> emit) async {
    emit(AppointmentAddLoadingState());
    final syncResult = await sync("donotdeleteordublicate@wlv.ac.uk");

    syncResult!.fold((failure) {
      emit(AddAppointmentErrorState(message: mapFailureToMessage(failure)));
    }, (syncData) {
      emit(AppointmentAddLoadedSuccessState(syncData));
    });
  }

  FutureOr<void> appointmentAddUpdateButtonPressEvent(AppointmentAddUpdateButtonPressEvent event, Emitter<AppointmentAddState> emit) async {
    await updateAppointment(event.appointmentModel);
    emit(AddAppointmentUpdatedState());
  }

  FutureOr<void> appointmentAddReadyToUpdateEvent(AppointmentAddReadyToUpdateEvent event, Emitter<AppointmentAddState> emit) {
    // emit(appointmentAddReadyToUpdateState(event.appointmentModel.imagePath));
  }
}
