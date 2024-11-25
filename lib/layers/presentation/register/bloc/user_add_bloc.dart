import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:fitness_app/core/mappers/map_failure_to_message.dart';
import 'package:fitness_app/layers/presentation/register/bloc/user_add_event.dart';
import 'package:fitness_app/layers/presentation/register/bloc/user_add_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/db/db_helper.dart';
import '../../../../core/model/user_model.dart';
import '../../../../core/util/input_converter.dart';
import '../../../../resources/strings_manager.dart';
import '../../../domain/register/usecases/add_user.dart';
import '../../../domain/register/usecases/update_user.dart';

class UserAddBloc extends Bloc<UserAddEvent, UserAddState> {
  final AddUser addUser;
  final UpdateUser updateUser;
  final InputConverter inputConverter;

  final DatabaseHelper dbHelper = DatabaseHelper();
  UserAddBloc({
    required this.addUser,
    required this.updateUser,
    required this.inputConverter,
  }) : super(UserAddInitialState()) {
    on<UserAddInitialEvent>(postAddInitialEvent);
    on<UserAddReadyToUpdateEvent>(postAddReadyToUpdateEvent);
    on<UserAddPickFromGalaryButtonPressEvent>(addPostPickFromGalaryButtonPressEvent);
    on<UserAddPickFromCameraButtonPressEvent>(addPostPickFromCameraButtonPressEvent);
    on<UserAddSaveButtonPressEvent>(userAddSaveButtonPressEvent);
    on<UserAddUpdateButtonPressEvent>(postAddUpdateButtonPressEvent);
  }

  FutureOr<void> addPostPickFromGalaryButtonPressEvent(UserAddPickFromGalaryButtonPressEvent event, Emitter<UserAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddUserImagePickedFromGalaryState(imagePath));
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

  FutureOr<void> addPostPickFromCameraButtonPressEvent(UserAddPickFromCameraButtonPressEvent event, Emitter<UserAddState> emit) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      pickedFile = photo;
      File image = File(pickedFile.path);
      Uint8List? uint8list = await getBytesFromImage(image);
      String imagePath = await saveImage(uint8list);
      emit(AddUserImagePickedFromCameraState(imagePath));
    }
  }

  FutureOr<void> postAddInitialEvent(UserAddInitialEvent event, Emitter<UserAddState> emit) {
    emit(UserAddInitialState());
  }

  FutureOr<void> postAddUpdateButtonPressEvent(UserAddUpdateButtonPressEvent event, Emitter<UserAddState> emit) async {
    await updateUser(event.updatedUser);
    emit(AddUserUpdatedState());
  }

  FutureOr<void> postAddReadyToUpdateEvent(UserAddReadyToUpdateEvent event, Emitter<UserAddState> emit) {
    // emit(PostAddReadyToUpdateState(event.postModel.imagePath));
  }

  FutureOr<void> userAddSaveButtonPressEvent(UserAddSaveButtonPressEvent event, Emitter<UserAddState> emit) async {
    final ageEither = inputConverter.stringToUnsignedInteger(event.age);
    late int age;
    ageEither.fold((failure) {
      emit(AddUserErrorState(message: AppStrings.invalidInputFailureMessage));
    }, (integer) {
      age = integer;
      emit(AddUserLoadingState());
    });

    UserModel newUser = UserModel(
      age: age,
      email: event.email,
      gender: event.gender,
      institutionEmail: event.institutionEmail,
      name: event.name,
      password: event.password,
      role: event.role,
    );
    final failureOrSuccess = await addUser(newUser);
    failureOrSuccess!.fold((failure) {
      emit(AddUserErrorState(message: mapFailureToMessage(failure)));
    }, (success) {
      emit(AddUserSavedState());
    });
  }
}
