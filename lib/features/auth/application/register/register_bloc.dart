import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/errors/map_failure_to_message.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import 'package:fitness_app/features/auth/application/register/register_event.dart';
import 'package:fitness_app/features/auth/domain/usecases/add_user.dart';
import 'package:fitness_app/features/auth/domain/usecases/update_user.dart';

import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required AddUser addUser,
    required UpdateUser updateUser,
    required ImagePickerService imagePickerService,
  })  : _addUser = addUser,
        _updateUser = updateUser,
        _imagePickerService = imagePickerService,
        super(const RegisterState()) {
    on<UserAddInitialEvent>(_onInitial);
    on<UserAddReadyToUpdateEvent>(_onReadyToUpdate);
    on<UserAddPickFromGalaryButtonPressEvent>(_onPickFromGallery);
    on<UserAddPickFromCameraButtonPressEvent>(_onPickFromCamera);
    on<UserAddSaveButtonPressEvent>(_onSavePressed);
    on<UserAddUpdateButtonPressEvent>(_onUpdatePressed);
  }

  final AddUser _addUser;
  final UpdateUser _updateUser;
  final ImagePickerService _imagePickerService;

  void _onInitial(UserAddInitialEvent event, Emitter<RegisterState> emit) {
    emit(const RegisterState());
  }

  void _onReadyToUpdate(
    UserAddReadyToUpdateEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      status: RegisterStatus.editing,
      clearError: true,
    ));
  }

  FutureOr<void> _onPickFromGallery(
    UserAddPickFromGalaryButtonPressEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      status: RegisterStatus.pickingImage,
      clearError: true,
    ));
    final path = await _imagePickerService.pickFromGallery();
    emit(state.copyWith(
      status: RegisterStatus.editing,
      imagePath: path,
      clearError: true,
      clearImage: path == null,
    ));
  }

  FutureOr<void> _onPickFromCamera(
    UserAddPickFromCameraButtonPressEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      status: RegisterStatus.pickingImage,
      clearError: true,
    ));
    final path = await _imagePickerService.pickFromCamera();
    emit(state.copyWith(
      status: RegisterStatus.editing,
      imagePath: path,
      clearError: true,
      clearImage: path == null,
    ));
  }

  FutureOr<void> _onSavePressed(
    UserAddSaveButtonPressEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      status: RegisterStatus.saving,
      clearError: true,
    ));
    final result = await _addUser(event.user);
    if (result == null) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Unexpected error, please try again.',
      ));
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: mapFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        status: RegisterStatus.saved,
        clearError: true,
      )),
    );
  }

  FutureOr<void> _onUpdatePressed(
    UserAddUpdateButtonPressEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(
      status: RegisterStatus.saving,
      clearError: true,
    ));
    final result = await _updateUser(event.updatedUser);
    if (result == null) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'Unexpected error, please try again.',
      ));
      return;
    }
    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: mapFailureToMessage(failure),
      )),
      (_) => emit(state.copyWith(
        status: RegisterStatus.updated,
        clearError: true,
      )),
    );
  }
}
