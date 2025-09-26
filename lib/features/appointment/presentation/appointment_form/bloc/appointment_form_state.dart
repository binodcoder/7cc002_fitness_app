import 'package:equatable/equatable.dart';
import 'package:fitness_app/features/appointment/data/models/sync_data_model.dart';
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
  final SyncModel syncModel;
  const AppointmentFormLoaded({required this.syncModel});
  AppointmentFormLoaded copyWith({SyncModel? syncModel}) {
    return AppointmentFormLoaded(syncModel: syncModel ?? this.syncModel);
  }

  @override
  List<Object?> get props => [syncModel];
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

