import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class EventActionState extends EventState {
  const EventActionState();
}

class EventInitialState extends EventState {
  const EventInitialState();
}

class EventLoadingState extends EventState {
  const EventLoadingState();
}

class EventLoadedSuccessState extends EventState {
  final List<Appointment> appointments;
  const EventLoadedSuccessState({required this.appointments});
  EventLoadedSuccessState copyWith({List<Appointment>? appointments}) {
    return EventLoadedSuccessState(
        appointments: appointments ?? this.appointments);
  }

  @override
  List<Object?> get props => [appointments];
}

class EventErrorState extends EventState {
  final String message;
  const EventErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventNavigateToAddEventActionState extends EventActionState {
  const EventNavigateToAddEventActionState();
}

class EventNavigateToDetailPageActionState extends EventActionState {
  final Appointment appointment;

  const EventNavigateToDetailPageActionState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class EventNavigateToUpdatePageActionState extends EventActionState {
  final Appointment appointment;
  final DateTime focusedDay;
  const EventNavigateToUpdatePageActionState(
      {required this.appointment, required this.focusedDay});

  @override
  List<Object?> get props => [appointment, focusedDay];
}

class EventItemDeletedActionState extends EventActionState {
  const EventItemDeletedActionState();
}

class EventDaySelectedState extends EventState {
  final List<Appointment> appointments;
  const EventDaySelectedState({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class EventItemsDeletedActionState extends EventActionState {
  const EventItemsDeletedActionState();
}
