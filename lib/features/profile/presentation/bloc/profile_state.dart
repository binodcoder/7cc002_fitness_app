part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, saving, saved, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    bool clearProfile = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: clearProfile ? null : (profile ?? this.profile),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
