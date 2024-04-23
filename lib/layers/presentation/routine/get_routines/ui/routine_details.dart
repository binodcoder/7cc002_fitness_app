import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    Size size = MediaQuery.of(context).size;
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
        title: const Text(
          AppStrings.routineDetails,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            isThreeLine: true,
            dense: true,
            contentPadding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            tileColor: ColorManager.white,
            title: Text(
              widget.routineModel!.name,
              style: const TextStyle(
                fontSize: FontSize.s20,
              ),
            ),
            subtitle: Column(
              children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Duration: ${widget.routineModel!.duration.toString()} minutes",
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.routineModel!.source,
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      widget.routineModel!.description,
                    )),
              ],
            ),
            trailing: Text(
              widget.routineModel!.difficulty,
              style: const TextStyle(fontSize: FontSize.s14),
            ),
          ),
          SizedBox(
            height: AppHeight.h4,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.routineModel!.exercises!.length,
              itemBuilder: (context, index) {
                var exerciseModel = widget.routineModel!.exercises![index];
                return Slidable(
                  endActionPane: ActionPane(
                    extentRatio: 0.46,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          // postBloc.add(RoutineEditButtonClickedEvent(exerciseModel));
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      )
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.all(size.width * 0.02),
                    // color: ColorManager.white,
                    child: ListTile(
                      title: Text(exerciseModel.name),
                      subtitle: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          children: [
                            Text(exerciseModel.difficulty),
                            Text(exerciseModel.equipment),
                            Text(exerciseModel.description),
                          ],
                        ),
                      ),
                      trailing: Text(exerciseModel.targetMuscleGroups),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
