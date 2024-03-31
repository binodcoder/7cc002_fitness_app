import '../../../../../core/model/appointment_model.dart';

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

class EventNavigateToAddEventActionState extends EventActionState {}

class EventNavigateToDetailPageActionState extends EventActionState {
  final AppointmentModel appointmentModel;

  EventNavigateToDetailPageActionState(this.appointmentModel);
}

class EventNavigateToUpdatePageActionState extends EventActionState {}

class EventItemDeletedActionState extends EventActionState {}

class EventDaySelectedState extends EventState {
  final List<AppointmentModel> appointmentModels;

  EventDaySelectedState(this.appointmentModels);
}

class EventItemsDeletedActionState extends EventActionState {}
