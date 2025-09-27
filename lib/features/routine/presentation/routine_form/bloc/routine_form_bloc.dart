import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_event.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/bloc/routine_form_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../domain/usecases/add_routine.dart';
import '../../../domain/usecases/update_routine.dart';

class RoutineFormBloc extends Bloc<RoutineFormEvent, RoutineFormState> {
  final AddRoutine addRoutine;
  final UpdateRoutine updateRoutine;
  RoutineFormBloc({
    required this.addRoutine,
    required this.updateRoutine,
  }) : super(const RoutineFormInitialState()) {
    on<RoutineFormInitialEvent>(routineAddInitialEvent);
    on<RoutineFormReadyToUpdateEvent>(routineAddReadyToUpdateEvent);
    on<RoutineFormPickFromGalleryButtonPressEvent>(
        addRoutinePickFromGalleryButtonPressEvent);
    on<RoutineFormPickFromCameraButtonPressEvent>(
        addRoutinePickFromCameraButtonPressEvent);
    on<RoutineFormSaveButtonPressEvent>(addRoutineSaveButtonPressEvent);
    on<RoutineFormUpdateButtonPressEvent>(routineAddUpdateButtonPressEvent);
  }

  FutureOr<void> addRoutinePickFromGalleryButtonPressEvent(
      RoutineFormPickFromGalleryButtonPressEvent event,
      Emitter<RoutineFormState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(RoutineFormImagePickedFromGalleryState(imagePath: imagePath));
    }
  }

  Future<Uint8List?> getBytesFromImage(File? image) async {
    Uint8List? bytes;
    if (image != null) {
      bytes = await image.readAsBytes();
    }
    return bytes;
  }

  Future<String> saveImage(Uint8List? imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    String imagePath =
        '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData!);
    return imagePath;
  }

  FutureOr<void> addRoutinePickFromCameraButtonPressEvent(
      RoutineFormPickFromCameraButtonPressEvent event,
      Emitter<RoutineFormState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(RoutineFormImagePickedFromCameraState(imagePath: imagePath));
    }
  }

  FutureOr<void> addRoutineSaveButtonPressEvent(
      RoutineFormSaveButtonPressEvent event,
      Emitter<RoutineFormState> emit) async {
    emit(const RoutineFormLoadingState());
    final result = await addRoutine(event.newRoutine);
    result!.fold((failure) {
      emit(const RoutineFormErrorState());
    }, (result) {
      emit(const RoutineFormSavedActionState());
    });
  }

  FutureOr<void> routineAddInitialEvent(
      RoutineFormInitialEvent event, Emitter<RoutineFormState> emit) {
    emit(const RoutineFormInitialState());
  }

  FutureOr<void> routineAddUpdateButtonPressEvent(
      RoutineFormUpdateButtonPressEvent event,
      Emitter<RoutineFormState> emit) async {
    emit(const RoutineFormLoadingState());
    final result = await updateRoutine(event.updatedRoutine);
    result!.fold((failure) {
      emit(const RoutineFormErrorState());
    }, (result) {
      emit(const RoutineFormUpdatedActionState());
    });
  }

  FutureOr<void> routineAddReadyToUpdateEvent(
      RoutineFormReadyToUpdateEvent event, Emitter<RoutineFormState> emit) {
    // emit(RoutineAddReadyToUpdateState(event.RoutineModel.imagePath));
  }
}
