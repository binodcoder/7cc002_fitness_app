import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/app/injection_container.dart';
import '../../../domain/usecases/add_appointment.dart';
import '../../../domain/usecases/sync.dart';
import '../../../domain/usecases/update_appointment.dart';
import 'appointment_form_event.dart';
import 'appointment_form_state.dart';

class AppointmentFormBloc
    extends Bloc<AppointmentFormEvent, AppointmentFormState> {
  final AddAppointment addAppointment;
  final UpdateAppointment updateAppointment;
  final Sync sync;

  AppointmentFormBloc({
    required this.addAppointment,
    required this.updateAppointment,
    required this.sync,
  }) : super(const AppointmentFormInitial()) {
    on<AppointmentFormInitialized>(_onInitialized);
    on<AppointmentCreateRequested>(_onCreateRequested);
    on<AppointmentUpdateRequested>(_onUpdateRequested);
  }

  FutureOr<void> _onInitialized(AppointmentFormInitialized event,
      Emitter<AppointmentFormState> emit) async {
    emit(const AppointmentFormLoading());
    // Email parameter is unused for Firebase, but avoid magic string
    // by reading from persisted session when available.
    final email = sl<SharedPreferences>().getString('user_email') ?? '';
    final syncResult = await sync(email);
    syncResult!.fold((failure) {
      emit(AppointmentFormError(message: mapFailureToMessage(failure)));
    }, (syncData) {
      emit(AppointmentFormLoaded(syncEntity: syncData));
    });
  }

  FutureOr<void> _onCreateRequested(AppointmentCreateRequested event,
      Emitter<AppointmentFormState> emit) async {
    emit(const AppointmentFormLoading());
    final result = await addAppointment(event.appointment);
    result!.fold((failure) {
      emit(AppointmentFormError(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(const AppointmentCreateSuccess());
    });
  }

  FutureOr<void> _onUpdateRequested(AppointmentUpdateRequested event,
      Emitter<AppointmentFormState> emit) async {
    emit(const AppointmentFormLoading());
    final result = await updateAppointment(event.appointment);
    result!.fold((failure) {
      emit(AppointmentFormError(message: mapFailureToMessage(failure)));
    }, (result) {
      emit(const AppointmentUpdateSuccess());
    });
  }
}
