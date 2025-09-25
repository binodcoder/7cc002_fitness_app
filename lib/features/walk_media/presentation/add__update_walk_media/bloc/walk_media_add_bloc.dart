import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/theme/tokens/app_colors.dart';
import 'package:fitness_app/features/walk_media/presentation/add__update_walk_media/bloc/walk_media_add_event.dart';
import 'package:fitness_app/features/walk_media/presentation/add__update_walk_media/bloc/walk_media_add_state.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fitness_app/shared/data/local/db_helper.dart';
import '../../../domain/usecases/add_walk_media.dart';
import '../../../domain/usecases/update_walk_media.dart';

class WalkMediaAddBloc extends Bloc<WalkMediaAddEvent, WalkMediaAddState> {
  final AddWalkMedia addWalkMedia;
  final UpdateWalkMedia updateWalkMedia;

  final DatabaseHelper dbHelper = DatabaseHelper();
  WalkMediaAddBloc({
    required this.addWalkMedia,
    required this.updateWalkMedia,
  }) : super(const WalkMediaAddInitialState()) {
    on<WalkMediaAddInitialEvent>(walkMediaAddInitialEvent);
    on<WalkMediaAddReadyToUpdateEvent>(walkMediaAddReadyToUpdateEvent);
    on<WalkMediaAddPickFromGalaryButtonPressEvent>(
        addwalkMediaPickFromGalaryButtonPressEvent);
    on<WalkMediaAddPickFromCameraButtonPressEvent>(
        addwalkMediaPickFromCameraButtonPressEvent);
    on<WalkMediaAddSaveButtonPressEvent>(addWalkMediaSaveButtonPressEvent);
    on<WalkMediaAddUpdateButtonPressEvent>(walkMediaAddUpdateButtonPressEvent);
  }

  FutureOr<void> addwalkMediaPickFromGalaryButtonPressEvent(
      WalkMediaAddPickFromGalaryButtonPressEvent event,
      Emitter<WalkMediaAddState> emit) async {
    ImagePicker picker = ImagePicker();
    //  XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      CroppedFile croppedFile = await cropImage(photo);
      File image = File(croppedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddWalkMediaImagePickedFromGalaryState(imagePath: imagePath));
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

  FutureOr<void> addwalkMediaPickFromCameraButtonPressEvent(
      WalkMediaAddPickFromCameraButtonPressEvent event,
      Emitter<WalkMediaAddState> emit) async {
    ImagePicker picker = ImagePicker();
    // XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      CroppedFile croppedFile = await cropImage(photo);
      File image = File(croppedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddWalkMediaImagePickedFromCameraState(imagePath: imagePath));
    }
  }

  Future<CroppedFile> cropImage(XFile photo) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: photo.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: ColorManager.lightBlue,
          toolbarWidgetColor: ColorManager.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile!;
  }

  FutureOr<void> addWalkMediaSaveButtonPressEvent(
      WalkMediaAddSaveButtonPressEvent event,
      Emitter<WalkMediaAddState> emit) async {
    emit(const AddWalkMediaLoadingState());
    final result = await addWalkMedia(event.newWalkMedia);
    result!.fold((failure) {
      emit(const AddWalkMediaErrorState());
    }, (result) {
      emit(const AddWalkMediaSavedState());
    });
  }

  FutureOr<void> walkMediaAddInitialEvent(
      WalkMediaAddInitialEvent event, Emitter<WalkMediaAddState> emit) {
    emit(const WalkMediaAddInitialState());
  }

  FutureOr<void> walkMediaAddUpdateButtonPressEvent(
      WalkMediaAddUpdateButtonPressEvent event,
      Emitter<WalkMediaAddState> emit) async {
    emit(const AddWalkMediaLoadingState());
    final result = await updateWalkMedia(event.updatedWalkMedia);
    result!.fold((failure) {
      emit(const AddWalkMediaErrorState());
    }, (result) {
      emit(const AddWalkMediaUpdatedState());
    });
  }

  FutureOr<void> walkMediaAddReadyToUpdateEvent(
      WalkMediaAddReadyToUpdateEvent event, Emitter<WalkMediaAddState> emit) {
    // emit(walkMediaAddReadyToUpdateState(event.walkMediaModel.imagePath));
  }
}
