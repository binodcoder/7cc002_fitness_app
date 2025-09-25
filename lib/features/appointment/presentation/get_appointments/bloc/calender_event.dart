import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CalenderEvent extends Equatable {
  const CalenderEvent();

  @override
  List<Object?> get props => const [];
}

class CalenderInitialEvent extends CalenderEvent {
  const CalenderInitialEvent();
}

class CalenderEditButtonClickedEvent extends CalenderEvent {
  const CalenderEditButtonClickedEvent();
}

class CalenderDeleteButtonClickedEvent extends CalenderEvent {
  final Appointment appointment;
  const CalenderDeleteButtonClickedEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalenderDeleteAllButtonClickedEvent extends CalenderEvent {
  const CalenderDeleteAllButtonClickedEvent();
}

class CalenderAddButtonClickedEvent extends CalenderEvent {
  final DateTime selectedDay;
  const CalenderAddButtonClickedEvent({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class CalenderTileNavigateEvent extends CalenderEvent {
  final Appointment appointment;
  const CalenderTileNavigateEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalenderDaySelectEvent extends CalenderEvent {
  final List<Appointment> appointments;
  final DateTime selectedDay;
  const CalenderDaySelectEvent({required this.selectedDay, required this.appointments});

  @override
  List<Object?> get props => [selectedDay, appointments];
}
