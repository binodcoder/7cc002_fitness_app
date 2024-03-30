import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/presentation_layer/routine/add_update_routine/bloc/routine_add_event.dart';
import 'package:fitness_app/layers/presentation_layer/routine/add_update_routine/bloc/routine_add_state.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/db/db_helper.dart';
import '../../../../domain_layer/routine/usecases/add_routine.dart';
import '../../../../domain_layer/routine/usecases/get_routines.dart';
import '../../../../domain_layer/routine/usecases/update_routine.dart';


class RoutineAddBloc extends Bloc<RoutineAddEvent, RoutineAddState> {
  final AddRoutine addRoutine;
  final UpdateRoutine updateRoutine;
 // final GetRoutines getRoutine;
  final DatabaseHelper dbHelper = DatabaseHelper();
  RoutineAddBloc({required this.addRoutine, required this.updateRoutine,  }) : super(RoutineAddInitialState()) {
    on<RoutineAddInitialEvent>(postAddInitialEvent);
    on<RoutineAddReadyToUpdateEvent>(postAddReadyToUpdateEvent);
    on<RoutineAddPickFromGalaryButtonPressEvent>(addPostPickFromGalaryButtonPressEvent);
    on<RoutineAddPickFromCameraButtonPressEvent>(addPostPickFromCameraButtonPressEvent);
    on<RoutineAddSaveButtonPressEvent>(addRoutineSaveButtonPressEvent);
    on<RoutineAddUpdateButtonPressEvent>(postAddUpdateButtonPressEvent);
  }

  FutureOr<void> addPostPickFromGalaryButtonPressEvent(RoutineAddPickFromGalaryButtonPressEvent event, Emitter<RoutineAddState> emit) async {
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
    String imagePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData!);
    return imagePath;
  }

  FutureOr<void> addPostPickFromCameraButtonPressEvent(RoutineAddPickFromCameraButtonPressEvent event, Emitter<RoutineAddState> emit) async {
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

  FutureOr<void> addRoutineSaveButtonPressEvent(RoutineAddSaveButtonPressEvent event, Emitter<RoutineAddState> emit) async {
    await addRoutine(event.newRoutine);
    emit(AddRoutineSavedState());
  }

  FutureOr<void> postAddInitialEvent(RoutineAddInitialEvent event, Emitter<RoutineAddState> emit) {
    emit(RoutineAddInitialState());
  }

  FutureOr<void> postAddUpdateButtonPressEvent(RoutineAddUpdateButtonPressEvent event, Emitter<RoutineAddState> emit) async {
    await updateRoutine(event.updatedRoutine);
    emit(AddRoutineUpdatedState());
  }

  FutureOr<void> postAddReadyToUpdateEvent(RoutineAddReadyToUpdateEvent event, Emitter<RoutineAddState> emit) {
   // emit(PostAddReadyToUpdateState(event.postModel.imagePath));
  }
}
