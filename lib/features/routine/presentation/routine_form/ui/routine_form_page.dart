import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/core/widgets/custom_text_form_field.dart';
import '../bloc/routine_form_bloc.dart';
import '../bloc/routine_form_event.dart';
import '../bloc/routine_form_state.dart';
import 'package:fitness_app/features/routine/domain/entities/exercise.dart' as entity;

class RoutineFormPage extends StatefulWidget {
  const RoutineFormPage({
    super.key,
    this.routine,
  });

  final Routine? routine;

  @override
  State<RoutineFormPage> createState() => _RoutineFormPageState();
}

class _RoutineFormPageState extends State<RoutineFormPage> {
  final TextEditingController routineNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController difficultyController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final List<_ExerciseItemData> _exerciseItems = [];

  @override
  void initState() {
    if (widget.routine != null) {
      routineNameController.text = widget.routine!.name;
      descriptionController.text = widget.routine!.description;
      difficultyController.text = widget.routine!.difficulty;
      durationController.text = widget.routine!.duration.toString();
      sourceController.text = widget.routine!.source;
      // Prefill exercises when editing an existing routine
      for (final ex in widget.routine!.exercises) {
        _exerciseItems.add(_ExerciseItemData.fromEntity(ex));
      }
      routineFormBloc
          .add(RoutineFormReadyToUpdateEvent(routine: widget.routine!));
    } else {
      routineFormBloc.add(const RoutineFormInitialEvent());
    }
    super.initState();
  }

  final RoutineFormBloc routineFormBloc = sl<RoutineFormBloc>();

  @override
  void dispose() {
    routineNameController.dispose();
    descriptionController.dispose();
    difficultyController.dispose();
    durationController.dispose();
    sourceController.dispose();
    for (final e in _exerciseItems) {
      e.name.dispose();
      e.description.dispose();
      e.targetMuscleGroups.dispose();
      e.difficulty.dispose();
      e.equipment.dispose();
      e.imageUrl.dispose();
      e.videoUrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);
    return BlocConsumer<RoutineFormBloc, RoutineFormState>(
      bloc: routineFormBloc,
      listenWhen: (previous, current) => current is RoutineFormActionState,
      buildWhen: (previous, current) => current is! RoutineFormActionState,
      listener: (context, state) {
        if (state is RoutineFormLoadingState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is RoutineFormSavedActionState) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is RoutineFormUpdatedActionState) {
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is RoutineFormErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding routine',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
          if (!mounted) return;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorManager.primary,
              title: Text(
                widget.routine == null
                    ? strings.addRoutine
                    : strings.updateRoutine,
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
                  decoration: BoxDecoration(
                    color: ColorManager.white,
                    borderRadius: BorderRadius.circular(
                      AppRadius.r20,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppHeight.h10),
                      CustomTextFormField(
                        label: 'RoutineName',
                        controller: routineNameController,
                        hint: 'Routine Name',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Description',
                        controller: descriptionController,
                        hint: 'Description',
                        minLines: 3,
                        maxLines: 5,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Difficulty',
                        controller: difficultyController,
                        hint: 'Difficulty',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Duration',
                        controller: durationController,
                        hint: 'Duration (minutes)',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      CustomTextFormField(
                        label: 'Source',
                        controller: sourceController,
                        hint: 'Source',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? '*Required' : null,
                      ),
                      SizedBox(height: AppHeight.h20),
                      Text(
                        'Exercises',
                        style: getRegularStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(height: AppHeight.h10),
                      if (_exerciseItems.isEmpty)
                        const Text(
                          'No exercises added yet. Tap "+ Add Exercise".',
                          style: TextStyle(color: ColorManager.grey),
                        ),
                      for (int i = 0; i < _exerciseItems.length; i++)
                        _ExerciseFormCard(
                          key: ValueKey(_exerciseItems[i].key),
                          index: i,
                          data: _exerciseItems[i],
                          onRemove: () {
                            setState(() => _exerciseItems.removeAt(i));
                          },
                        ),
                      SizedBox(height: AppHeight.h10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise'),
                          onPressed: () {
                            setState(() {
                              _exerciseItems.add(_ExerciseItemData());
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h30,
                      ),
                      CustomButton(
                        child: Text(
                          widget.routine == null
                              ? strings.addRoutine
                              : strings.updateRoutine,
                          style: getRegularStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        onPressed: () async {
                          var routineName = routineNameController.text;
                          var description = descriptionController.text;
                          var difficulty = difficultyController.text;
                          var duration = durationController.text;
                          var source = sourceController.text;
                          final exercises =
                              _exerciseItems.map((e) => e.toEntity()).toList();
                          if (routineName.isNotEmpty && duration.isNotEmpty) {
                            if (widget.routine != null) {
                              var updatedRoutine = Routine(
                                id: widget.routine!.id,
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                                exercises: exercises,
                              );
                              routineFormBloc.add(
                                  RoutineFormUpdateButtonPressEvent(
                                      updatedRoutine: updatedRoutine));
                            } else {
                              var newRoutine = Routine(
                                name: routineName,
                                description: description,
                                difficulty: difficulty,
                                duration: int.parse(duration),
                                source: source,
                                exercises: exercises,
                              );
                              routineFormBloc.add(
                                  RoutineFormSaveButtonPressEvent(
                                      newRoutine: newRoutine));
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                    ],
                  ),
                  // ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExerciseItemData {
  final String key = UniqueKey().toString();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController targetMuscleGroups = TextEditingController();
  final TextEditingController difficulty = TextEditingController();
  final TextEditingController equipment = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController videoUrl = TextEditingController();
  int? id;

  _ExerciseItemData();

  factory _ExerciseItemData.fromEntity(entity.Exercise ex) {
    final d = _ExerciseItemData();
    d.id = ex.id;
    d.name.text = ex.name;
    d.description.text = ex.description;
    d.targetMuscleGroups.text = ex.targetMuscleGroups;
    d.difficulty.text = ex.difficulty;
    d.equipment.text = ex.equipment;
    d.imageUrl.text = ex.imageUrl;
    d.videoUrl.text = ex.videoUrl ?? '';
    return d;
  }

  entity.Exercise toEntity() {
    final generatedId = id ?? DateTime.now().millisecondsSinceEpoch;
    return entity.Exercise(
      id: generatedId,
      name: name.text.trim(),
      description: description.text.trim(),
      targetMuscleGroups: targetMuscleGroups.text.trim(),
      difficulty: difficulty.text.trim(),
      equipment: equipment.text.trim(),
      imageUrl: imageUrl.text.trim(),
      videoUrl: videoUrl.text.trim().isEmpty ? null : videoUrl.text.trim(),
    );
  }
}

class _ExerciseFormCard extends StatelessWidget {
  final int index;
  final _ExerciseItemData data;
  final VoidCallback onRemove;

  const _ExerciseFormCard({
    super.key,
    required this.index,
    required this.data,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exercise #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: onRemove,
                  tooltip: 'Remove exercise',
                )
              ],
            ),
            CustomTextFormField(
              label: 'Name',
              controller: data.name,
              hint: 'Exercise name',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Description',
              controller: data.description,
              hint: 'What to do',
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Target Muscle Groups',
              controller: data.targetMuscleGroups,
              hint: 'e.g. Chest, Triceps',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Difficulty',
              controller: data.difficulty,
              hint: 'Easy / Medium / Hard',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Equipment',
              controller: data.equipment,
              hint: 'e.g. Dumbbells, None',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Image URL',
              controller: data.imageUrl,
              hint: 'https://... (optional)',
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              label: 'Video URL',
              controller: data.videoUrl,
              hint: 'https://... (optional)',
            ),
          ],
        ),
      ),
    );
  }
}
