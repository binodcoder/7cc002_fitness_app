import 'package:flutter/material.dart';
import '../../../../../core/model/live_training_model.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/values_manager.dart';

class LiveTrainingDetailsPage extends StatefulWidget {
  const LiveTrainingDetailsPage({
    Key? key,
    this.liveTrainingModel,
  }) : super(key: key);

  final LiveTrainingModel? liveTrainingModel;

  @override
  State<LiveTrainingDetailsPage> createState() => _LiveTrainingDetailsPageState();
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

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorManager.primary,
          ),
        ),
        backgroundColor: ColorManager.white,
        elevation: 0,
        title: Text(
          'LiveTraining Details',
          style: TextStyle(
            color: ColorManager.primary,
            fontWeight: FontWeight.bold,
          ),
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
                widget.liveTrainingModel!.trainingDate.toString(),
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                widget.liveTrainingModel!.startTime,
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