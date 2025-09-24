import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

abstract class CalenderState {}

abstract class CalenderActionState extends CalenderState {}

class CalenderInitialState extends CalenderState {}

class CalenderLoadingState extends CalenderState {}

class CalenderLoadedSuccessState extends CalenderState {
  final List<Appointment> appointments;
  CalenderLoadedSuccessState(this.appointments);
  CalenderLoadedSuccessState copyWith({List<Appointment>? appointments}) {
    return CalenderLoadedSuccessState(appointments ?? this.appointments);
  }
}

class CalenderErrorState extends CalenderState {}

class CalenderNavigateToAddCalenderActionState extends CalenderActionState {
  final DateTime focusedDay;

  CalenderNavigateToAddCalenderActionState(this.focusedDay);
}

class CalenderNavigateToDetailPageActionState extends CalenderActionState {
  final Appointment appointment;

  CalenderNavigateToDetailPageActionState(this.appointment);
}

class CalenderNavigateToUpdatePageActionState extends CalenderActionState {}

class CalenderItemDeletedActionState extends CalenderActionState {}

class CalenderDaySelectedState extends CalenderState {
  final List<Appointment> appointments;

  CalenderDaySelectedState(this.appointments);
}

class CalenderItemsDeletedActionState extends CalenderActionState {}
