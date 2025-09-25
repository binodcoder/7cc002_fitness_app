import 'package:flutter/material.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class ImagePickerButtons extends StatelessWidget {
  final VoidCallback onPickGallery;
  final VoidCallback onPickCamera;

  const ImagePickerButtons({
    super.key,
    required this.onPickGallery,
    required this.onPickCamera,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.redWhite,
        borderRadius: BorderRadius.circular(AppRadius.r10),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onPickGallery,
            child: Row(
              children: [
                const Icon(Icons.file_copy_outlined, color: Colors.blue),
                const SizedBox(width: 6.0),
                Text(
                  AppStrings.of(context).pickGalary,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          const Text('|', style: TextStyle(fontSize: 30)),
          InkWell(
            onTap: onPickCamera,
            child: Row(
              children: [
                const Icon(Icons.camera_enhance_outlined, color: Colors.blue),
                const SizedBox(width: 6.0),
                Text(
                  AppStrings.of(context).camera,
                  style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
