import 'package:flutter/material.dart';

import 'package:fitness_app/core/model/walk_media_model.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class WalkMediaDetailsPage extends StatefulWidget {
  const WalkMediaDetailsPage({
    Key? key,
    this.walkMediaModel,
  }) : super(key: key);

  final WalkMediaModel? walkMediaModel;

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
                widget.walkMediaModel!.mediaUrl,
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                widget.walkMediaModel!.userId.toString(),
                style: const TextStyle(fontSize: FontSize.s14),
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
