part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => const [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileSaved extends ProfileEvent {
  final UserProfile profile;
  const ProfileSaved(this.profile);

  @override
  List<Object?> get props => [profile];
}

