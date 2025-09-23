import 'package:fitness_app/core/model/appointment_model.dart';

abstract class EventState {}

abstract class EventActionState extends EventState {}

class EventInitialState extends EventState {}

class EventLoadingState extends EventState {}

class EventLoadedSuccessState extends EventState {
  final List<AppointmentModel> appointmentModels;
  EventLoadedSuccessState(this.appointmentModels);
  EventLoadedSuccessState copyWith({List<AppointmentModel>? appointmentModels}) {
    return EventLoadedSuccessState(appointmentModels ?? this.appointmentModels);
  }
}

class EventErrorState extends EventState {}

class EventNavigateToAddEventActionState extends EventActionState {
  // final AppointmentModel appointmentModel;
  // final DateTime focusedDay;
  // EventNavigateToAddEventActionState(this.appointmentModel, this.focusedDay);
}

class EventNavigateToDetailPageActionState extends EventActionState {
  final AppointmentModel appointmentModel;

  EventNavigateToDetailPageActionState(this.appointmentModel);
}

class EventNavigateToUpdatePageActionState extends EventActionState {
  final AppointmentModel appointmentModel;
  final DateTime focusedDay;
  EventNavigateToUpdatePageActionState(this.appointmentModel, this.focusedDay);
}

class EventItemDeletedActionState extends EventActionState {}

class EventDaySelectedState extends EventState {
  final List<AppointmentModel> appointmentModels;
  EventDaySelectedState(this.appointmentModels);
}

class EventItemsDeletedActionState extends EventActionState {}
