import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/features/routine/presentation/add_update_routine/bloc/routine_add_event.dart';
import 'package:fitness_app/features/routine/presentation/add_update_routine/bloc/routine_add_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fitness_app/core/db/db_helper.dart';
import '../../../domain/usecases/add_routine.dart';
import '../../../domain/usecases/update_routine.dart';

class RoutineAddBloc extends Bloc<RoutineAddEvent, RoutineAddState> {
  final AddRoutine addRoutine;
  final UpdateRoutine updateRoutine;
  final DatabaseHelper dbHelper = DatabaseHelper();
  RoutineAddBloc({
    required this.addRoutine,
    required this.updateRoutine,
  }) : super(RoutineAddInitialState()) {
    on<RoutineAddInitialEvent>(routineAddInitialEvent);
    on<RoutineAddReadyToUpdateEvent>(routineAddReadyToUpdateEvent);
    on<RoutineAddPickFromGalaryButtonPressEvent>(
        addRoutinePickFromGalaryButtonPressEvent);
    on<RoutineAddPickFromCameraButtonPressEvent>(
        addRoutinePickFromCameraButtonPressEvent);
    on<RoutineAddSaveButtonPressEvent>(addRoutineSaveButtonPressEvent);
    on<RoutineAddUpdateButtonPressEvent>(routineAddUpdateButtonPressEvent);
  }

  FutureOr<void> addRoutinePickFromGalaryButtonPressEvent(
      RoutineAddPickFromGalaryButtonPressEvent event,
      Emitter<RoutineAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddRoutineImagePickedFromGalaryState(imagePath));
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
      RoutineAddPickFromCameraButtonPressEvent event,
      Emitter<RoutineAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddRoutineImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> addRoutineSaveButtonPressEvent(
      RoutineAddSaveButtonPressEvent event,
      Emitter<RoutineAddState> emit) async {
    emit(AddRoutineLoadingState());
    final result = await addRoutine(event.newRoutine);
    result!.fold((failure) {
      emit(AddRoutineErrorState());
    }, (result) {
      emit(AddRoutineSavedActionState());
    });
  }

  FutureOr<void> routineAddInitialEvent(
      RoutineAddInitialEvent event, Emitter<RoutineAddState> emit) {
    emit(RoutineAddInitialState());
  }

  FutureOr<void> routineAddUpdateButtonPressEvent(
      RoutineAddUpdateButtonPressEvent event,
      Emitter<RoutineAddState> emit) async {
    emit(AddRoutineLoadingState());
    final result = await updateRoutine(event.updatedRoutine);
    result!.fold((failure) {
      emit(AddRoutineErrorState());
    }, (result) {
      emit(AddRoutineUpdatedActionState());
    });
  }

  FutureOr<void> routineAddReadyToUpdateEvent(
      RoutineAddReadyToUpdateEvent event, Emitter<RoutineAddState> emit) {
    // emit(RoutineAddReadyToUpdateState(event.RoutineModel.imagePath));
  }
}
