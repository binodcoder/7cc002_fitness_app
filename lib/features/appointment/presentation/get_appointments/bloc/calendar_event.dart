import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => const [];
}

class CalendarInitialized extends CalendarEvent {
  const CalendarInitialized();
}

class CalendarEditButtonClicked extends CalendarEvent {
  const CalendarEditButtonClicked();
}

class CalendarDeleteButtonClicked extends CalendarEvent {
  final Appointment appointment;
  const CalendarDeleteButtonClicked({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalendarDeleteAllButtonClicked extends CalendarEvent {
  const CalendarDeleteAllButtonClicked();
}

class CalendarAddButtonClicked extends CalendarEvent {
  final DateTime selectedDay;
  const CalendarAddButtonClicked({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class CalendarTileNavigate extends CalendarEvent {
  final Appointment appointment;
  const CalendarTileNavigate({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalendarStatusChangeRequested extends CalendarEvent {
  final Appointment appointment;
  final String status; // 'accepted' | 'declined' | 'pending'
  const CalendarStatusChangeRequested({
    required this.appointment,
    required this.status,
  });

  @override
  List<Object?> get props => [appointment, status];
}

class CalendarDaySelected extends CalendarEvent {
  final List<Appointment> appointments;
  final DateTime selectedDay;
  const CalendarDaySelected(
      {required this.selectedDay, required this.appointments});

  @override
  List<Object?> get props => [selectedDay, appointments];
}
