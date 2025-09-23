import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

abstract class CalenderEvent {}

class CalenderInitialEvent extends CalenderEvent {}

class CalenderEditButtonClickedEvent extends CalenderEvent {}

class CalenderDeleteButtonClickedEvent extends CalenderEvent {
  final AppointmentModel appointmentModel;
  CalenderDeleteButtonClickedEvent(this.appointmentModel);
}

class CalenderDeleteAllButtonClickedEvent extends CalenderEvent {}

class CalenderAddButtonClickedEvent extends CalenderEvent {
  final DateTime selectedDay;
  CalenderAddButtonClickedEvent(this.selectedDay);
}

class CalenderTileNavigateEvent extends CalenderEvent {
  final AppointmentModel appointmentModel;
  CalenderTileNavigateEvent(this.appointmentModel);
}

class CalenderDaySelectEvent extends CalenderEvent {
  List<AppointmentModel> appointmentModels;
  final DateTime selectedDay;
  CalenderDaySelectEvent(this.selectedDay, this.appointmentModels);
}
