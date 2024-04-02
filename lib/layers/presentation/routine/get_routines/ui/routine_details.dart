import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../../../../../core/model/routine_model.dart';
import '../../../../../resources/colour_manager.dart';
import '../../../../../resources/font_manager.dart';
import '../../../../../resources/values_manager.dart';

class RoutineDetailsPage extends StatefulWidget {
  const RoutineDetailsPage({
    Key? key,
    this.routineModel,
  }) : super(key: key);

  final RoutineModel? routineModel;

  @override
  State<RoutineDetailsPage> createState() => _RoutineDetailsPageState();
}

class _RoutineDetailsPageState extends State<RoutineDetailsPage> {
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
          ),
        ),
        title: const Text(
          AppStrings.routineDetails,
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
                widget.routineModel!.source,
                style: const TextStyle(
                  fontSize: FontSize.s20,
                ),
              ),
              subtitle: Text(
                widget.routineModel!.description,
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
