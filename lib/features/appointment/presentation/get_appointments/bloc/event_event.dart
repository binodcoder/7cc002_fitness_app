import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

abstract class EventEvent {}

class EventInitialEvent extends EventEvent {}

class EventEditButtonClickedEvent extends EventEvent {
  final DateTime focusedDay;
  final AppointmentModel appointmentModel;
  EventEditButtonClickedEvent(this.appointmentModel, this.focusedDay);
}

class EventDeleteButtonClickedEvent extends EventEvent {
  final AppointmentModel appointmentModel;
  EventDeleteButtonClickedEvent(this.appointmentModel);
}

class EventDeleteAllButtonClickedEvent extends EventEvent {}

class EventAddButtonClickedEvent extends EventEvent {}

class EventTileNavigateEvent extends EventEvent {
  final AppointmentModel appointmentModel;
  EventTileNavigateEvent(this.appointmentModel);
}

class EventDaySelectEvent extends EventEvent {
  List<AppointmentModel> appointmentModels;
  final DateTime selectedDay;
  EventDaySelectEvent(this.selectedDay, this.appointmentModels);
}
