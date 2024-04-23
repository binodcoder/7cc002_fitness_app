import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../../../../../core/model/walk_media_model.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/values_manager.dart';

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

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: const Text(
          AppStrings.titleWalkMediaLabel,
        ),
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
