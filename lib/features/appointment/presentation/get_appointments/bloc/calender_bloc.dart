import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_app/shared/data/local/db_helper.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../domain/usecases/delete_appointment.dart';
import '../../../domain/usecases/get_appointments.dart';
import 'calender_event.dart';
import 'calender_state.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';

class CalenderBloc extends Bloc<CalenderEvent, CalenderState> {
  final GetAppointments getAppointments;
  final DeleteAppointment deleteAppointment;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Appointment> selectedCalenders = [];
  CalenderBloc({
    required this.getAppointments,
    required this.deleteAppointment,
  }) : super(const CalenderInitialState()) {
    on<CalenderInitialEvent>(calenderInitialEvent);
    on<CalenderEditButtonClickedEvent>(calenderEditButtonClickedEvent);
    on<CalenderDeleteButtonClickedEvent>(calenderDeleteButtonClickedEvent);
    on<CalenderDeleteAllButtonClickedEvent>(
        calenderDeleteAllButtonClickedEvent);
    on<CalenderAddButtonClickedEvent>(calenderAddButtonClickedEvent);
    on<CalenderTileNavigateEvent>(calenderTileNavigateEvent);
    on<CalenderDaySelectEvent>(calenderDaySelectEvent);
  }

  FutureOr<void> calenderInitialEvent(
      CalenderInitialEvent event, Emitter<CalenderState> emit) async {
    emit(const CalenderLoadingState());
    final appointmentsResult = await getAppointments(NoParams());

    appointmentsResult!.fold((failure) {
      emit(CalenderErrorState(message: mapFailureToMessage(failure)));
    }, (appointments) {
      emit(CalenderLoadedSuccessState(appointments: appointments));
    });
  }

  FutureOr<void> calenderEditButtonClickedEvent(
      CalenderEditButtonClickedEvent event, Emitter<CalenderState> emit) {}

  FutureOr<void> calenderDeleteButtonClickedEvent(
      CalenderDeleteButtonClickedEvent event,
      Emitter<CalenderState> emit) async {
    final result = await deleteAppointment(event.appointment.id!);

    result!.fold((failure) {
      emit(CalenderShowErrorActionState(
          message: mapFailureToMessage(failure)));
    }, (response) {
      emit(const CalenderItemDeletedActionState());
    });

    // await dbHelper.deleteCalender(event.CalenderModel.id);
    // List<CalenderModel> CalenderList = await dbHelper.getCalenders();
    // emit(CalenderLoadedSuccessState(CalenderList));
  }

  FutureOr<void> calenderDeleteAllButtonClickedEvent(
      CalenderDeleteAllButtonClickedEvent event,
      Emitter<CalenderState> emit) async {
    // for (var element in selectedCalenders) {
    //   await dbHelper.deleteCalender(element.id);
    // }
    // List<CalenderModel> CalenderList = await dbHelper.getCalenders();
    // emit(CalenderLoadedSuccessState(CalenderList));
  }

  FutureOr<void> calenderAddButtonClickedEvent(
      CalenderAddButtonClickedEvent event, Emitter<CalenderState> emit) {
    emit(CalenderNavigateToAddCalenderActionState(
        focusedDay: event.selectedDay));
  }

  FutureOr<void> calenderTileNavigateEvent(
      CalenderTileNavigateEvent event, Emitter<CalenderState> emit) {
    emit(CalenderNavigateToDetailPageActionState(
        appointment: event.appointment));
  }

  FutureOr<void> calenderDaySelectEvent(
      CalenderDaySelectEvent e, Emitter<CalenderState> emit) {
    // emit(CalenderLoadedSuccessState(e.appointmentModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
    emit(CalenderDaySelectedState(
        appointments: e.appointments
            .where((event) => isSameDay(event.date, e.selectedDay))
            .toList()));
  }
}
