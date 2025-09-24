import 'package:flutter/material.dart';

import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
// Removed unused theme imports after extracting body widget
import 'package:fitness_app/features/walk/presentation/walk/get_walks/widgets/walk_details_body.dart';

class WalkDetailsPage extends StatefulWidget {
  const WalkDetailsPage({
    Key? key,
    this.walk,
  }) : super(key: key);

  final Walk? walk;

  @override
  State<WalkDetailsPage> createState() => _WalkDetailsPageState();
}

class _WalkDetailsPageState extends State<WalkDetailsPage> {
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

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ColorManager.primary,
          ),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: const Text(
          'Walk Details',
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: WalkDetailsBody(walk: widget.walk!),
    );
  }
}
