import 'package:flutter/material.dart';

class ImagePickerButtons extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  const ImagePickerButtons({super.key, required this.onPickGallery, required this.onPickCamera});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: onPickGallery,
          icon: const Icon(Icons.photo),
          label: const Text('Gallery'),
        ),
        ElevatedButton.icon(
          onPressed: onPickCamera,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Camera'),
        ),
      ],
    );
  }
}

