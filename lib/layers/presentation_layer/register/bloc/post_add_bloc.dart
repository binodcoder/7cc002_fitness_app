import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/layers/presentation_layer/register/bloc/post_add_event.dart';
import 'package:fitness_app/layers/presentation_layer/register/bloc/post_add_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/db/db_helper.dart';
 import '../../../domain_layer/register/usecases/post_post.dart';
import '../../../domain_layer/register/usecases/update_post.dart';
import '../../../domain_layer/routine/usecases/get_routines.dart';


class PostAddBloc extends Bloc<PostAddEvent, PostAddState> {
  final PostPosts postPosts;
  final UpdatePost updatePost;
  final GetRoutines getPosts;
  final DatabaseHelper dbHelper = DatabaseHelper();
  PostAddBloc({required this.postPosts, required this.updatePost, required this.getPosts}) : super(PostAddInitialState()) {
    on<PostAddInitialEvent>(postAddInitialEvent);
    on<PostAddReadyToUpdateEvent>(postAddReadyToUpdateEvent);
    on<PostAddPickFromGalaryButtonPressEvent>(addPostPickFromGalaryButtonPressEvent);
    on<PostAddPickFromCameraButtonPressEvent>(addPostPickFromCameraButtonPressEvent);
    on<PostAddSaveButtonPressEvent>(addPostSaveButtonPressEvent);
    on<PostAddUpdateButtonPressEvent>(postAddUpdateButtonPressEvent);
  }

  FutureOr<void> addPostPickFromGalaryButtonPressEvent(PostAddPickFromGalaryButtonPressEvent event, Emitter<PostAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromGalaryState(imagePath));
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

  FutureOr<void> addPostPickFromCameraButtonPressEvent(PostAddPickFromCameraButtonPressEvent event, Emitter<PostAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddPostImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> addPostSaveButtonPressEvent(PostAddSaveButtonPressEvent event, Emitter<PostAddState> emit) async {
    await postPosts(event.newPost);
    emit(AddPostSavedState());
  }

  FutureOr<void> postAddInitialEvent(PostAddInitialEvent event, Emitter<PostAddState> emit) {
    emit(PostAddInitialState());
  }

  FutureOr<void> postAddUpdateButtonPressEvent(PostAddUpdateButtonPressEvent event, Emitter<PostAddState> emit) async {
    await updatePost(event.updatedPost);
    emit(AddPostUpdatedState());
  }

  FutureOr<void> postAddReadyToUpdateEvent(PostAddReadyToUpdateEvent event, Emitter<PostAddState> emit) {
   // emit(PostAddReadyToUpdateState(event.postModel.imagePath));
  }
}
