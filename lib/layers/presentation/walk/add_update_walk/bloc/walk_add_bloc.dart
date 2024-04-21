import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/presentation/walk/add_update_walk/bloc/walk_add_event.dart';
import 'package:fitness_app/layers/presentation/walk/add_update_walk/bloc/walk_add_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../domain/walk/usecases/add_walk.dart';
import '../../../../domain/walk/usecases/update_walk.dart';

class WalkAddBloc extends Bloc<WalkAddEvent, WalkAddState> {
  final AddWalk addWalk;
  final UpdateWalk updateWalk;
  WalkAddBloc({required this.addWalk, required this.updateWalk}) : super(WalkAddInitialState()) {
    on<WalkAddInitialEvent>(walkAddInitialEvent);
    on<WalkAddReadyToUpdateEvent>(walkAddReadyToUpdateEvent);
    on<WalkAddPickFromGalaryButtonPressEvent>(addwalkPickFromGalaryButtonPressEvent);
    on<WalkAddPickFromCameraButtonPressEvent>(addwalkPickFromCameraButtonPressEvent);
    on<WalkAddSaveButtonPressEvent>(addWalkSaveButtonPressEvent);
    on<WalkAddUpdateButtonPressEvent>(walkAddUpdateButtonPressEvent);
  }

  FutureOr<void> addwalkPickFromGalaryButtonPressEvent(WalkAddPickFromGalaryButtonPressEvent event, Emitter<WalkAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddWalkImagePickedFromGalaryState(imagePath));
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

  FutureOr<void> addwalkPickFromCameraButtonPressEvent(WalkAddPickFromCameraButtonPressEvent event, Emitter<WalkAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddWalkImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> addWalkSaveButtonPressEvent(WalkAddSaveButtonPressEvent event, Emitter<WalkAddState> emit) async {
    final result = await addWalk(event.newWalk);
    result!.fold((failure) {
      emit(AddWalkErrorState());
    }, (result) {
      emit(AddWalkSavedState());
    });
  }

  FutureOr<void> walkAddInitialEvent(WalkAddInitialEvent event, Emitter<WalkAddState> emit) {
    emit(WalkAddInitialState());
  }

  FutureOr<void> walkAddUpdateButtonPressEvent(WalkAddUpdateButtonPressEvent event, Emitter<WalkAddState> emit) async {
    final result = await updateWalk(event.updatedWalk);
    result!.fold((failure) {
      emit(AddWalkErrorState());
    }, (result) {
      emit(AddWalkUpdatedState());
    });
  }

  FutureOr<void> walkAddReadyToUpdateEvent(WalkAddReadyToUpdateEvent event, Emitter<WalkAddState> emit) {
    // emit(walkAddReadyToUpdateState(event.walkModel.imagePath));
  }
}
