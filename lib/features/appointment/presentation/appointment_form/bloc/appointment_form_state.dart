import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AppointmentFormState extends Equatable {
  const AppointmentFormState();

  @override
  List<Object?> get props => const [];
}

@immutable
abstract class AppointmentFormActionState extends AppointmentFormState {
  const AppointmentFormActionState();
}

class AppointmentFormLoading extends AppointmentFormState {
  const AppointmentFormLoading();
}

class AppointmentFormLoaded extends AppointmentFormState {
  final SyncEntity syncEntity;
  const AppointmentFormLoaded({required this.syncEntity});
  AppointmentFormLoaded copyWith({SyncEntity? syncEntity}) {
    return AppointmentFormLoaded(syncEntity: syncEntity ?? this.syncEntity);
  }

  @override
  List<Object?> get props => [syncEntity];
}

class AppointmentFormInitial extends AppointmentFormState {
  const AppointmentFormInitial();
}

class AppointmentCreateSuccess extends AppointmentFormActionState {
  const AppointmentCreateSuccess();
}

class AppointmentUpdateSuccess extends AppointmentFormActionState {
  const AppointmentUpdateSuccess();
}

class AppointmentFormError extends AppointmentFormActionState {
  final String message;
  const AppointmentFormError({required this.message});

  @override
  List<Object?> get props => [message];
}
