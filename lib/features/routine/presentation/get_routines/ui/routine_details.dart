import 'package:flutter/material.dart';
import 'package:fitness_app/features/routine/data/models/routine_model.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
// Removed unused font_manager import
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/widgets/routine_details_header.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/widgets/exercise_list_tile.dart';

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
    final strings = AppStrings.of(context);
    return Scaffold(
      backgroundColor: ColorManager.darkWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
        title: Text(strings.routineDetails),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RoutineDetailsHeader(routineModel: widget.routineModel!),
          SizedBox(height: AppHeight.h4),
          Expanded(
            child: ListView.builder(
              itemCount: widget.routineModel!.exercises!.length,
              itemBuilder: (context, index) {
                var exerciseModel = widget.routineModel!.exercises![index];
                return ExerciseListTile(
                  exerciseModel: exerciseModel,
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
