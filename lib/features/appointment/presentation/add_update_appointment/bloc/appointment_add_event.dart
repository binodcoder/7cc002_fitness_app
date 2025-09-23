import 'package:fitness_app/features/appointment/data/models/appointment_model.dart';

abstract class AppointmentAddEvent {}

class AppointmentAddInitialEvent extends AppointmentAddEvent {}

class AppointmentAddSaveButtonPressEvent extends AppointmentAddEvent {
  final AppointmentModel appointmentModel;
  AppointmentAddSaveButtonPressEvent(this.appointmentModel);
}

class AppointmentAddUpdateButtonPressEvent extends AppointmentAddEvent {
  final AppointmentModel appointmentModel;
  AppointmentAddUpdateButtonPressEvent(this.appointmentModel);
}

class AppointmentAddReadyToUpdateEvent extends AppointmentAddEvent {
  final AppointmentModel appointmentModel;
  AppointmentAddReadyToUpdateEvent(this.appointmentModel);
}
