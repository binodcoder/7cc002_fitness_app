import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_app/features/profile/domain/usecases/get_profile.dart';
import 'package:fitness_app/features/profile/domain/usecases/upsert_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required GetProfile getProfile, required UpsertProfile upsertProfile})
      : _getProfile = getProfile,
        _upsertProfile = upsertProfile,
        super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileSaved>(_onSaved);
  }

  final GetProfile _getProfile;
  final UpsertProfile _upsertProfile;

  FutureOr<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));
    final res = await _getProfile();
    res.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: mapFailureToMessage(failure),
      )),
      (profile) => emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        clearError: true,
      )),
    );
  }

  FutureOr<void> _onSaved(ProfileSaved event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.saving, clearError: true));
    final res = await _upsertProfile(event.profile);
    res.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: mapFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(status: ProfileStatus.saved, clearError: true)),
    );
  }
}

