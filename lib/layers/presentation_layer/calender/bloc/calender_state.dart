

import '../../../../core/model/appointment_model.dart';

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

class CalenderNavigateToAddCalenderActionState extends CalenderActionState {}

class CalenderNavigateToDetailPageActionState extends CalenderActionState {
  final AppointmentModel appointmentModel;

  CalenderNavigateToDetailPageActionState(this.appointmentModel);
}

class CalenderNavigateToUpdatePageActionState extends CalenderActionState {}

class CalenderItemDeletedActionState extends CalenderActionState {}

class CalenderItemSelectedActionState extends CalenderActionState {}

class CalenderItemsDeletedActionState extends CalenderActionState {}
