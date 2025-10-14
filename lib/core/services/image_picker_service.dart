import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

abstract class ImagePickerService {
  Future<String?> pickFromGallery();
  Future<String?> pickFromCamera();
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> _getBytesFromImage(File? image) async {
    if (image == null) return null;
    return image.readAsBytes();
  }

  Future<String> _saveImage(Uint8List imageData) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath =
        '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData);
    return imagePath;
  }

  @override
  Future<String?> pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return null;
    final bytes = await _getBytesFromImage(File(photo.path));
    if (bytes == null) return null;
    return _saveImage(bytes);
  }

  @override
  Future<String?> pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;
    final bytes = await _getBytesFromImage(File(photo.path));
    if (bytes == null) return null;
    return _saveImage(bytes);
  }
}
