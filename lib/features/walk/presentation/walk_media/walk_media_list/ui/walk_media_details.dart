import 'package:flutter/material.dart';

import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/widgets/walk_media_details_body.dart';

class WalkMediaDetailsPage extends StatefulWidget {
  const WalkMediaDetailsPage({
    Key? key,
    this.walkMedia,
  }) : super(key: key);

  final WalkMedia? walkMedia;

  @override
  State<WalkMediaDetailsPage> createState() => _WalkMediaDetailsPageState();
}

class _WalkMediaDetailsPageState extends State<WalkMediaDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: ColorManager.primary),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: const Text(
          'Walk Media Details',
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: WalkMediaDetailsBody(walkMedia: widget.walkMedia!),
    );
  }
}
