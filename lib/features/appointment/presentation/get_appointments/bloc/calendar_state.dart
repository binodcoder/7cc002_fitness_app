import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class CalendarActionState extends CalendarState {
  const CalendarActionState();
}

class CalendarInitialState extends CalendarState {
  const CalendarInitialState();
}

class CalendarLoadingState extends CalendarState {
  const CalendarLoadingState();
}

class CalendarLoadedSuccessState extends CalendarState {
  final List<Appointment> appointments;
  const CalendarLoadedSuccessState({required this.appointments});

  CalendarLoadedSuccessState copyWith({List<Appointment>? appointments}) {
    return CalendarLoadedSuccessState(appointments: appointments ?? this.appointments);
  }

  @override
  List<Object?> get props => [appointments];
}

class CalendarDaySelectedState extends CalendarState {
  final List<Appointment> appointments;

  const CalendarDaySelectedState({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class CalendarErrorState extends CalendarState {
  final String message;

  const CalendarErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class CalendarShowErrorActionState extends CalendarActionState {
  final String message;

  const CalendarShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class CalendarNavigateToAddActionState extends CalendarActionState {
  final DateTime focusedDay;

  const CalendarNavigateToAddActionState({required this.focusedDay});

  @override
  List<Object?> get props => [focusedDay];
}

class CalendarNavigateToDetailPageActionState extends CalendarActionState {
  final Appointment appointment;

  const CalendarNavigateToDetailPageActionState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalendarNavigateToUpdatePageActionState extends CalendarActionState {
  const CalendarNavigateToUpdatePageActionState();
}

class CalendarItemDeletedActionState extends CalendarActionState {
  const CalendarItemDeletedActionState();
}

class CalendarItemsDeletedActionState extends CalendarActionState {
  const CalendarItemsDeletedActionState();
}

