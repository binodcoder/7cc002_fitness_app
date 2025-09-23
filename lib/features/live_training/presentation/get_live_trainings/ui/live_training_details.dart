import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitness_app/features/live_training/data/models/live_training_model.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class LiveTrainingDetailsPage extends StatefulWidget {
  const LiveTrainingDetailsPage({
    Key? key,
    this.liveTrainingModel,
  }) : super(key: key);

  final LiveTrainingModel? liveTrainingModel;

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
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            SizedBox(
              height: AppHeight.h10,
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              tileColor: ColorManager.white,
              title: Text(
                DateFormat("yMd")
                    .format(widget.liveTrainingModel!.trainingDate),
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                widget.liveTrainingModel!.startTime,
                style: const TextStyle(fontSize: FontSize.s14),
              ),
              trailing: const Text(
                "code: test",
                style: TextStyle(fontSize: FontSize.s14),
              ),
            ),
            SizedBox(
              height: AppHeight.h20,
            ),
            SizedBox(
              height: AppHeight.h20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '',
                style: TextStyle(fontSize: FontSize.s12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
