import 'package:flutter/material.dart';

import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
// Unused local theme imports removed after extracting body widget
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/widgets/live_training_details_body.dart';

class LiveTrainingDetailsPage extends StatefulWidget {
  const LiveTrainingDetailsPage({
    Key? key,
    this.liveTraining,
  }) : super(key: key);

  final LiveTraining? liveTraining;

  @override
  State<LiveTrainingDetailsPage> createState() =>
      _LiveTrainingDetailsPageState();
}

class _LiveTrainingDetailsPageState extends State<LiveTrainingDetailsPage> {
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(strings.titleLiveTrainingLabel),
        centerTitle: true,
      ),
      body: LiveTrainingDetailsBody(
        liveTraining: widget.liveTraining!,
      ),
    );
  }
}
