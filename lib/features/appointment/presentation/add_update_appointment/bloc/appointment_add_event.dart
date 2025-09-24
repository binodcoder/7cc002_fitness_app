import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';

abstract class AppointmentAddEvent {}

class AppointmentAddInitialEvent extends AppointmentAddEvent {}

class AppointmentAddSaveButtonPressEvent extends AppointmentAddEvent {
  final Appointment appointment;
  AppointmentAddSaveButtonPressEvent(this.appointment);
}

class AppointmentAddUpdateButtonPressEvent extends AppointmentAddEvent {
  final Appointment appointment;
  AppointmentAddUpdateButtonPressEvent(this.appointment);
}

class AppointmentAddReadyToUpdateEvent extends AppointmentAddEvent {
  final Appointment appointment;
  AppointmentAddReadyToUpdateEvent(this.appointment);
}
