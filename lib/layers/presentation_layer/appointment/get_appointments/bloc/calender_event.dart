 
import 'package:fitness_app/core/model/appointment_model.dart';

abstract class CalenderEvent {}

class CalenderInitialEvent extends CalenderEvent {}

class CalenderEditButtonClickedEvent extends CalenderEvent {}

class CalenderDeleteButtonClickedEvent extends CalenderEvent {
  final AppointmentModel  appointmentModel;
  CalenderDeleteButtonClickedEvent(this.appointmentModel);
}

class CalenderDeleteAllButtonClickedEvent extends CalenderEvent {}

class CalenderAddButtonClickedEvent extends CalenderEvent {}

class CalenderTileNavigateEvent extends CalenderEvent {
  final AppointmentModel appointmentModel;
  CalenderTileNavigateEvent(this.appointmentModel);
}

 
