import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_app/core/db/db_helper.dart';
import 'package:fitness_app/core/usecases/usecase.dart';
import '../../../../domain/appointment/usecases/delete_appointment.dart';
import '../../../../domain/appointment/usecases/get_appointments.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetAppointments getAppointments;
  final DeleteAppointment deleteAppointment;
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<AppointmentModel> selectedEvents = [];
  EventBloc({
    required this.getAppointments,
    required this.deleteAppointment,
  }) : super(EventInitialState()) {
    on<EventInitialEvent>(eventInitialEvent);
    on<EventEditButtonClickedEvent>(eventEditButtonClickedEvent);
    on<EventDeleteButtonClickedEvent>(eventDeleteButtonClickedEvent);
    on<EventDeleteAllButtonClickedEvent>(eventDeleteAllButtonClickedEvent);
    on<EventAddButtonClickedEvent>(eventAddButtonClickedEvent);
    on<EventTileNavigateEvent>(eventTileNavigateEvent);
    on<EventDaySelectEvent>(eventDaySelectEvent);
  }

  FutureOr<void> eventInitialEvent(EventInitialEvent event, Emitter<EventState> emit) async {
    emit(EventLoadingState());
    final appointments = await getAppointments(NoParams());

    appointments!.fold((failure) {
      // emit(Error(message: _mapFailureToMessage(failure)));
    }, (appointments) {
      emit(EventLoadedSuccessState(appointments));
    });
  }

  FutureOr<void> eventEditButtonClickedEvent(EventEditButtonClickedEvent event, Emitter<EventState> emit) {
    emit(EventNavigateToUpdatePageActionState(event.appointmentModel, event.focusedDay));
  }

  FutureOr<void> eventDeleteButtonClickedEvent(EventDeleteButtonClickedEvent event, Emitter<EventState> emit) async {
    // await dbHelper.deleteEvent(event.EventModel.id);
    // List<EventModel> EventList = await dbHelper.getEvents();
    // emit(EventLoadedSuccessState(EventList));
  }

  FutureOr<void> eventDeleteAllButtonClickedEvent(EventDeleteAllButtonClickedEvent event, Emitter<EventState> emit) async {
    // for (var element in selectedEvents) {
    //   await dbHelper.deleteEvent(element.id);
    // }
    // List<EventModel> EventList = await dbHelper.getEvents();
    // emit(EventLoadedSuccessState(EventList));
  }

  FutureOr<void> eventAddButtonClickedEvent(EventAddButtonClickedEvent event, Emitter<EventState> emit) {
    emit(EventNavigateToAddEventActionState());
  }

  FutureOr<void> eventTileNavigateEvent(EventTileNavigateEvent event, Emitter<EventState> emit) {
    emit(EventNavigateToDetailPageActionState(event.appointmentModel));
  }

  FutureOr<void> eventDaySelectEvent(EventDaySelectEvent e, Emitter<EventState> emit) {
    // emit(EventLoadedSuccessState(e.appointmentModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
    emit(EventDaySelectedState(e.appointmentModels.where((event) => isSameDay(event.date, e.selectedDay)).toList()));
  }
}
