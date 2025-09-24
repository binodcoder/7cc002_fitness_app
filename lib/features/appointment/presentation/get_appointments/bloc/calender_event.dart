import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

abstract class CalenderEvent {}

class CalenderInitialEvent extends CalenderEvent {}

class CalenderEditButtonClickedEvent extends CalenderEvent {}

class CalenderDeleteButtonClickedEvent extends CalenderEvent {
  final Appointment appointment;
  CalenderDeleteButtonClickedEvent(this.appointment);
}

class CalenderDeleteAllButtonClickedEvent extends CalenderEvent {}

class CalenderAddButtonClickedEvent extends CalenderEvent {
  final DateTime selectedDay;
  CalenderAddButtonClickedEvent(this.selectedDay);
}

class CalenderTileNavigateEvent extends CalenderEvent {
  final Appointment appointment;
  CalenderTileNavigateEvent(this.appointment);
}

class CalenderDaySelectEvent extends CalenderEvent {
  List<Appointment> appointments;
  final DateTime selectedDay;
  CalenderDaySelectEvent(this.selectedDay, this.appointments);
}
