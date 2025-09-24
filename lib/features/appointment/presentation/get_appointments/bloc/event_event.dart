import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

abstract class EventEvent {}

class EventInitialEvent extends EventEvent {}

class EventEditButtonClickedEvent extends EventEvent {
  final DateTime focusedDay;
  final Appointment appointment;
  EventEditButtonClickedEvent(this.appointment, this.focusedDay);
}

class EventDeleteButtonClickedEvent extends EventEvent {
  final Appointment appointment;
  EventDeleteButtonClickedEvent(this.appointment);
}

class EventDeleteAllButtonClickedEvent extends EventEvent {}

class EventAddButtonClickedEvent extends EventEvent {}

class EventTileNavigateEvent extends EventEvent {
  final Appointment appointment;
  EventTileNavigateEvent(this.appointment);
}

class EventDaySelectEvent extends EventEvent {
  List<Appointment> appointments;
  final DateTime selectedDay;
  EventDaySelectEvent(this.selectedDay, this.appointments);
}
