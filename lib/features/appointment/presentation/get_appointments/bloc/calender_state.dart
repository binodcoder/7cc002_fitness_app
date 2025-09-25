import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CalenderState extends Equatable {
  const CalenderState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class CalenderActionState extends CalenderState {
  const CalenderActionState();
}

class CalenderInitialState extends CalenderState {
  const CalenderInitialState();
}

class CalenderLoadingState extends CalenderState {
  const CalenderLoadingState();
}

class CalenderLoadedSuccessState extends CalenderState {
  final List<Appointment> appointments;
  const CalenderLoadedSuccessState({required this.appointments});

  CalenderLoadedSuccessState copyWith({List<Appointment>? appointments}) {
    return CalenderLoadedSuccessState(
        appointments: appointments ?? this.appointments);
  }

  @override
  List<Object?> get props => [appointments];
}

class CalenderDaySelectedState extends CalenderState {
  final List<Appointment> appointments;

  const CalenderDaySelectedState({required this.appointments});

  @override
  List<Object?> get props => [appointments];
}

class CalenderErrorState extends CalenderState {
  final String message;

  const CalenderErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class CalenderShowErrorActionState extends CalenderActionState {
  final String message;

  const CalenderShowErrorActionState({required this.message});

  @override
  List<Object?> get props => [message];
}

class CalenderNavigateToAddCalenderActionState extends CalenderActionState {
  final DateTime focusedDay;

  const CalenderNavigateToAddCalenderActionState({required this.focusedDay});

  @override
  List<Object?> get props => [focusedDay];
}

class CalenderNavigateToDetailPageActionState extends CalenderActionState {
  final Appointment appointment;

  const CalenderNavigateToDetailPageActionState({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class CalenderNavigateToUpdatePageActionState extends CalenderActionState {
  const CalenderNavigateToUpdatePageActionState();
}

class CalenderItemDeletedActionState extends CalenderActionState {
  const CalenderItemDeletedActionState();
}

class CalenderItemsDeletedActionState extends CalenderActionState {
  const CalenderItemsDeletedActionState();
}
