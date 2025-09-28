import 'package:equatable/equatable.dart';

enum RegisterStatus {
  initial,
  editing,
  pickingImage,
  saving,
  saved,
  updated,
  failure,
}

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.imagePath,
    this.errorMessage,
  });

  final RegisterStatus status;
  final String? imagePath;
  final String? errorMessage;

  bool get isBusy =>
      status == RegisterStatus.pickingImage || status == RegisterStatus.saving;

  RegisterState copyWith({
    RegisterStatus? status,
    String? imagePath,
    bool clearImage = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, imagePath, errorMessage];
}
