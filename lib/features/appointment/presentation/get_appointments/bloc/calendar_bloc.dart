import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_appointment.dart';
import '../../../domain/usecases/get_appointments.dart';
import '../../../domain/usecases/update_appointment.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetAppointments getAppointments;
  final DeleteAppointment deleteAppointment;
  final UpdateAppointment updateAppointment;
  List<Appointment> selectedAppointments = [];
  CalendarBloc({
    required this.getAppointments,
    required this.deleteAppointment,
    required this.updateAppointment,
  }) : super(const CalendarInitialState()) {
    on<CalendarInitialized>(_onInitialized);
    on<CalendarEditButtonClicked>(_onEditButtonClicked);
    on<CalendarDeleteButtonClicked>(_onDeleteButtonClicked);
    on<CalendarDeleteAllButtonClicked>(_onDeleteAllButtonClicked);
    on<CalendarAddButtonClicked>(_onAddButtonClicked);
    on<CalendarTileNavigate>(_onTileNavigate);
    on<CalendarDaySelected>(_onDaySelected);
    on<CalendarStatusChangeRequested>(_onStatusChangeRequested);
  }

  FutureOr<void> _onInitialized(
      CalendarInitialized event, Emitter<CalendarState> emit) async {
    emit(const CalendarLoadingState());
    final appointmentsResult = await getAppointments(NoParams());

    appointmentsResult!.fold((failure) {
      emit(CalendarErrorState(message: mapFailureToMessage(failure)));
    }, (appointments) {
      emit(CalendarLoadedSuccessState(appointments: appointments));
    });
  }

  FutureOr<void> _onEditButtonClicked(
      CalendarEditButtonClicked event, Emitter<CalendarState> emit) {}

  FutureOr<void> _onDeleteButtonClicked(
      CalendarDeleteButtonClicked event, Emitter<CalendarState> emit) async {
    final result = await deleteAppointment(event.appointment.id!);

    result!.fold((failure) {
      emit(CalendarShowErrorActionState(message: mapFailureToMessage(failure)));
    }, (response) {
      emit(const CalendarItemDeletedActionState());
    });
  }

  FutureOr<void> _onDeleteAllButtonClicked(
      CalendarDeleteAllButtonClicked event, Emitter<CalendarState> emit) async {
    // Implement bulk delete if required in future
  }

  FutureOr<void> _onAddButtonClicked(
      CalendarAddButtonClicked event, Emitter<CalendarState> emit) {
    emit(CalendarNavigateToAddActionState(focusedDay: event.selectedDay));
  }

  FutureOr<void> _onTileNavigate(
      CalendarTileNavigate event, Emitter<CalendarState> emit) {
    emit(CalendarNavigateToDetailPageActionState(
        appointment: event.appointment));
  }

  FutureOr<void> _onDaySelected(
      CalendarDaySelected e, Emitter<CalendarState> emit) {
    emit(CalendarDaySelectedState(
        appointments: e.appointments
            .where((event) => isSameDay(event.date, e.selectedDay))
            .toList()));
  }

  FutureOr<void> _onStatusChangeRequested(CalendarStatusChangeRequested e,
      Emitter<CalendarState> emit) async {
    final appt = e.appointment;
    final updated = Appointment(
      id: appt.id,
      date: appt.date,
      endTime: appt.endTime,
      startTime: appt.startTime,
      trainerId: appt.trainerId,
      userId: appt.userId,
      remark: appt.remark,
      status: e.status,
    );
    final result = await updateAppointment(updated);
    result!.fold((failure) {
      emit(CalendarShowErrorActionState(message: mapFailureToMessage(failure)));
    }, (r) {
      emit(const CalendarItemUpdatedActionState());
    });
  }
}
