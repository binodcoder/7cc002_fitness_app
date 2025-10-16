import 'package:flutter/material.dart';

class ImagePickerButtons extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;
  final VoidCallback? onPickVideo;
  const ImagePickerButtons(
      {super.key,
      required this.onPickGallery,
      required this.onPickCamera,
      this.onPickVideo});

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onPickGallery,
          icon: const Icon(Icons.photo),
          label: const Text('Gallery'),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onPickCamera,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Camera'),
        ),
      ),
    ];
    if (onPickVideo != null) {
      buttons.addAll([
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPickVideo,
            icon: const Icon(Icons.videocam),
            label: const Text('Video'),
          ),
        ),
      ]);
    }
    return Row(children: buttons);
  }
}
