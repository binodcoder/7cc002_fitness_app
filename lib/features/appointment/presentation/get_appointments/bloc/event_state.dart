import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

abstract class EventState {}

abstract class EventActionState extends EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventLoadedSuccessState extends EventState {
  final List<Appointment> appointments;
  EventLoadedSuccessState(this.appointments);
  EventLoadedSuccessState copyWith({List<Appointment>? appointments}) {
    return EventLoadedSuccessState(appointments ?? this.appointments);
  }
}

class EventErrorState extends EventState {}

class EventNavigateToAddEventActionState extends EventActionState {
  // final AppointmentModel appointmentModel;
  // final DateTime focusedDay;
  // EventNavigateToAddEventActionState(this.appointmentModel, this.focusedDay);
}

class EventNavigateToDetailPageActionState extends EventActionState {
  final Appointment appointment;

  EventNavigateToDetailPageActionState(this.appointment);
}

class EventNavigateToUpdatePageActionState extends EventActionState {
  final Appointment appointment;
  final DateTime focusedDay;
  EventNavigateToUpdatePageActionState(this.appointment, this.focusedDay);
}

class EventItemDeletedActionState extends EventActionState {}

class EventDaySelectedState extends EventState {
  final List<Appointment> appointments;
  EventDaySelectedState(this.appointments);
}

class EventItemsDeletedActionState extends EventActionState {}
