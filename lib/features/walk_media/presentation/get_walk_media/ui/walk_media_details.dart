import 'package:flutter/material.dart';

import 'package:fitness_app/features/walk_media/domain/entities/walk_media.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
// Removed unused theme imports after extracting body widget
import 'package:fitness_app/features/walk_media/presentation/get_walk_media/widgets/walk_media_details_body.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    final strings = AppStrings.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(strings.titleWalkMediaLabel),
        centerTitle: true,
      ),
      body: WalkMediaDetailsBody(walkMedia: widget.walkMedia!),
    );
  }
}
