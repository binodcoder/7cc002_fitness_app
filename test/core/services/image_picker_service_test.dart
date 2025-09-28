import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:fitness_app/core/services/image_picker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakeImagePickerPlatform extends ImagePickerPlatform {
  XFile? _nextFile;

  void setNextFile(XFile? file) {
    _nextFile = file;
  }

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return _nextFile;
  }
}

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this._appDocsPath);
  final String _appDocsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => _appDocsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late _FakeImagePickerPlatform fakePicker;
  late PathProviderPlatform originalPathProvider;
  late ImagePickerPlatform originalImagePicker;

  setUp(() async {
    // Create isolated temp dir per test run.
    tempDir = await Directory.systemTemp.createTemp('image_picker_service_test_');

    // Swap out platform instances with fakes.
    originalPathProvider = PathProviderPlatform.instance;
    originalImagePicker = ImagePickerPlatform.instance;
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);
    fakePicker = _FakeImagePickerPlatform();
    ImagePickerPlatform.instance = fakePicker;
  });

  tearDown(() async {
    // Restore platform instances and clean temp dir.
    ImagePickerPlatform.instance = originalImagePicker;
    PathProviderPlatform.instance = originalPathProvider;
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('pickFromGallery returns null when user cancels', () async {
    fakePicker.setNextFile(null);
    final service = ImagePickerServiceImpl();
    final result = await service.pickFromGallery();
    expect(result, isNull);
  });

  test('pickFromCamera saves and returns new image path', () async {
    // Arrange: create a source image file with known bytes.
    final Uint8List sourceBytes = Uint8List.fromList(List<int>.generate(16, (i) => i));
    final File source = File('${tempDir.path}/source_camera.png');
    await source.writeAsBytes(sourceBytes);
    fakePicker.setNextFile(XFile(source.path));

    final service = ImagePickerServiceImpl();

    // Act
    final String? savedPath = await service.pickFromCamera();

    // Assert
    expect(savedPath, isNotNull);
    expect(savedPath, contains(tempDir.path));
    final savedFile = File(savedPath!);
    expect(await savedFile.exists(), isTrue);
    final savedBytes = await savedFile.readAsBytes();
    expect(savedBytes, sourceBytes);
  });

  test('pickFromGallery saves and returns new image path', () async {
    // Arrange: create a source image file with known bytes.
    final Uint8List sourceBytes = Uint8List.fromList(List<int>.generate(32, (i) => 255 - i));
    final File source = File('${tempDir.path}/source_gallery.png');
    await source.writeAsBytes(sourceBytes);
    fakePicker.setNextFile(XFile(source.path));

    final service = ImagePickerServiceImpl();

    // Act
    final String? savedPath = await service.pickFromGallery();

    // Assert
    expect(savedPath, isNotNull);
    expect(savedPath, contains(tempDir.path));
    final savedFile = File(savedPath!);
    expect(await savedFile.exists(), isTrue);
    final savedBytes = await savedFile.readAsBytes();
    expect(savedBytes, sourceBytes);
  });
}

