import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/bloc/walk_form_event.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/bloc/walk_form_state.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import '../../../domain/usecases/add_walk.dart';
import '../../../domain/usecases/update_walk.dart';

class WalkFormBloc extends Bloc<WalkFormEvent, WalkFormState> {
  final AddWalk addWalk;
  final UpdateWalk updateWalk;
  final ImagePickerService imagePickerService;
  WalkFormBloc({
    required this.addWalk,
    required this.updateWalk,
    required this.imagePickerService,
  }) : super(const WalkFormInitial()) {
    on<WalkFormInitialized>(walkFormInitialized);
    on<WalkFormReadyToEdit>(walkFormReadyToEdit);
    on<WalkFormPickFromGalleryPressed>(pickFromGalleryPressed);
    on<WalkFormPickFromCameraPressed>(pickFromCameraPressed);
    on<WalkFormCreatePressed>(createPressed);
    on<WalkFormUpdatePressed>(updatePressed);
  }

  FutureOr<void> pickFromGalleryPressed(
      WalkFormPickFromGalleryPressed event, Emitter<WalkFormState> emit) async {
    final path = await imagePickerService.pickFromGallery();
    if (path != null) emit(WalkFormImagePickedFromGallery(imagePath: path));
  }

  FutureOr<void> pickFromCameraPressed(
      WalkFormPickFromCameraPressed event, Emitter<WalkFormState> emit) async {
    final path = await imagePickerService.pickFromCamera();
    if (path != null) emit(WalkFormImagePickedFromCamera(imagePath: path));
  }

  FutureOr<void> createPressed(
      WalkFormCreatePressed event, Emitter<WalkFormState> emit) async {
    emit(const WalkFormLoading());
    final result = await addWalk(event.newWalk);
    result!.fold((failure) {
      emit(const WalkFormError());
    }, (result) {
      emit(const WalkFormCreateSuccess());
    });
  }

  FutureOr<void> walkFormInitialized(
      WalkFormInitialized event, Emitter<WalkFormState> emit) {
    emit(const WalkFormInitial());
  }

  FutureOr<void> updatePressed(
      WalkFormUpdatePressed event, Emitter<WalkFormState> emit) async {
    emit(const WalkFormLoading());
    final result = await updateWalk(event.updatedWalk);
    result!.fold((failure) {
      emit(const WalkFormError());
    }, (result) {
      emit(const WalkFormUpdateSuccess());
    });
  }

  FutureOr<void> walkFormReadyToEdit(
      WalkFormReadyToEdit event, Emitter<WalkFormState> emit) {
    // emit(walkAddReadyToUpdateState(event.walkModel.imagePath));
  }
}
