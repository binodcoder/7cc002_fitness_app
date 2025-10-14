import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => const [];
}

class EventInitialEvent extends EventEvent {
  const EventInitialEvent();
}

class EventEditButtonClickedEvent extends EventEvent {
  final DateTime focusedDay;
  final Appointment appointment;
  const EventEditButtonClickedEvent(
      {required this.appointment, required this.focusedDay});

  @override
  List<Object?> get props => [appointment, focusedDay];
}

class EventDeleteButtonClickedEvent extends EventEvent {
  final Appointment appointment;
  const EventDeleteButtonClickedEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class EventDeleteAllButtonClickedEvent extends EventEvent {
  const EventDeleteAllButtonClickedEvent();
}

class EventAddButtonClickedEvent extends EventEvent {
  const EventAddButtonClickedEvent();
}

class EventTileNavigateEvent extends EventEvent {
  final Appointment appointment;
  const EventTileNavigateEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class EventDaySelectEvent extends EventEvent {
  final List<Appointment> appointments;
  final DateTime selectedDay;
  const EventDaySelectEvent(
      {required this.selectedDay, required this.appointments});

  @override
  List<Object?> get props => [selectedDay, appointments];
}
