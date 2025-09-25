import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';
@immutable
abstract class AppointmentAddEvent extends Equatable {
  const AppointmentAddEvent();

  @override
  List<Object?> get props => const [];
}

class AppointmentAddInitialEvent extends AppointmentAddEvent {
  const AppointmentAddInitialEvent();
}

class AppointmentAddSaveButtonPressEvent extends AppointmentAddEvent {
  final Appointment appointment;
  const AppointmentAddSaveButtonPressEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class AppointmentAddUpdateButtonPressEvent extends AppointmentAddEvent {
  final Appointment appointment;
  const AppointmentAddUpdateButtonPressEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

class AppointmentAddReadyToUpdateEvent extends AppointmentAddEvent {
  final Appointment appointment;
  const AppointmentAddReadyToUpdateEvent({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}
