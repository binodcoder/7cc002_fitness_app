import 'package:equatable/equatable.dart';

enum UserAddStatus {
  initial,
  editing,
  pickingImage,
  saving,
  saved,
  updated,
  failure,
}

class UserAddState extends Equatable {
  const UserAddState({
    this.status = UserAddStatus.initial,
    this.imagePath,
    this.errorMessage,
  });

  final UserAddStatus status;
  final String? imagePath;
  final String? errorMessage;

  bool get isBusy =>
      status == UserAddStatus.pickingImage || status == UserAddStatus.saving;

  UserAddState copyWith({
    UserAddStatus? status,
    String? imagePath,
    bool clearImage = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserAddState(
      status: status ?? this.status,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, imagePath, errorMessage];
}
