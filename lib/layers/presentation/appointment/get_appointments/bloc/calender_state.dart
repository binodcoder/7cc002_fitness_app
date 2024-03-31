import '../../../../../core/model/appointment_model.dart';

abstract class CalenderState {}

abstract class CalenderActionState extends CalenderState {}

class CalenderInitialState extends CalenderState {}

class CalenderLoadingState extends CalenderState {}

class CalenderLoadedSuccessState extends CalenderState {
  final List<AppointmentModel> appointmentModels;
  CalenderLoadedSuccessState(this.appointmentModels);
  CalenderLoadedSuccessState copyWith({List<AppointmentModel>? appointmentModels}) {
    return CalenderLoadedSuccessState(appointmentModels ?? this.appointmentModels);
  }
}

class CalenderErrorState extends CalenderState {}

class CalenderNavigateToAddCalenderActionState extends CalenderActionState {
  final DateTime focusedDay;

  CalenderNavigateToAddCalenderActionState(this.focusedDay);
}

class CalenderNavigateToDetailPageActionState extends CalenderActionState {
  final AppointmentModel appointmentModel;

  CalenderNavigateToDetailPageActionState(this.appointmentModel);
}

class CalenderNavigateToUpdatePageActionState extends CalenderActionState {}

class CalenderItemDeletedActionState extends CalenderActionState {}

class CalenderDaySelectedState extends CalenderState {
  final List<AppointmentModel> appointmentModels;

  CalenderDaySelectedState(this.appointmentModels);
}

class CalenderItemsDeletedActionState extends CalenderActionState {}
