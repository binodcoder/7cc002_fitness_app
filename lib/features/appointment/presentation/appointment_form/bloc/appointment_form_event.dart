import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AppointmentFormEvent extends Equatable {
  const AppointmentFormEvent();

  @override
  List<Object?> get props => const [];
}

/// Triggers initial load (e.g., sync data such as trainers)
class AppointmentFormInitialized extends AppointmentFormEvent {
  const AppointmentFormInitialized();
}

/// User requests to create a new appointment
class AppointmentCreateRequested extends AppointmentFormEvent {
  final Appointment appointment;
  const AppointmentCreateRequested({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}

/// User requests to update an existing appointment
class AppointmentUpdateRequested extends AppointmentFormEvent {
  final Appointment appointment;
  const AppointmentUpdateRequested({required this.appointment});

  @override
  List<Object?> get props => [appointment];
}
