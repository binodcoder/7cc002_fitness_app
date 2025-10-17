import 'package:fitness_app/features/home/presentation/routine_form/ui/exercise_form_page.dart';
import 'package:fitness_app/features/home/presentation/routine_form/widgets/exercise_item_data.dart';
import 'package:fitness_app/features/home/presentation/routine_form/widgets/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import '../bloc/routine_form_bloc.dart';
import '../bloc/routine_form_event.dart';
import '../bloc/routine_form_state.dart';

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
  final TextEditingController durationController = TextEditingController();
  final List<ExerciseItemData> _exerciseItems = [];
  bool _loadingShown = false;
  int? _draftId; // generated id for new routine so we can update incrementally

  Future<String?> _promptText({
    required String title,
    required String initial,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) async {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => TextEditDialogPage(
          title: title,
          initial: initial,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          validator: validator,
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.routine != null) {
      routineNameController.text = widget.routine!.name;
      descriptionController.text = widget.routine!.description;
      durationController.text = widget.routine!.duration.toString();
      // Prefill exercises when editing an existing routine
      for (final ex in widget.routine!.exercises) {
        _exerciseItems.add(ExerciseItemData.fromEntity(ex));
      }
      routineFormBloc
          .add(RoutineFormReadyToUpdateEvent(routine: widget.routine!));
    } else {
      routineFormBloc.add(const RoutineFormInitialEvent());
    }
    super.initState();
  }

  final RoutineFormBloc routineFormBloc = sl<RoutineFormBloc>();

  Future<void> _saveRoutineIncremental() async {
    final name = routineNameController.text.trim();
    final desc = descriptionController.text.trim();
    final durStr = durationController.text.trim();
    final exercises = _exerciseItems.map((e) => e.toEntity()).toList();

    final hasMin = name.isNotEmpty && int.tryParse(durStr) != null;

    if (widget.routine != null || _draftId != null) {
      final id = widget.routine?.id ?? _draftId;
      if (id == null) return;
      final updated = Routine(
        id: id,
        name: name,
        description: desc,
        duration: int.tryParse(durStr) ?? (widget.routine?.duration ?? 0),
        source: widget.routine?.source ?? '',
        exercises: exercises,
      );
      routineFormBloc.add(
        RoutineFormUpdateButtonPressEvent(updatedRoutine: updated),
      );
    } else if (hasMin) {
      _draftId = DateTime.now().millisecondsSinceEpoch;
      final created = Routine(
        id: _draftId,
        name: name,
        description: desc,
        duration: int.parse(durStr),
        source: '',
        exercises: exercises,
      );
      routineFormBloc.add(
        RoutineFormSaveButtonPressEvent(newRoutine: created),
      );
    }
  }

  @override
  void dispose() {
    routineNameController.dispose();
    descriptionController.dispose();
    durationController.dispose();

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
          if (!_loadingShown) {
            _loadingShown = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        } else if (state is RoutineFormSavedActionState ||
            state is RoutineFormUpdatedActionState) {
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_loadingShown &&
                Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            _loadingShown = false;
            Fluttertoast.showToast(
              msg: 'Saved',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          });
        } else if (state is RoutineFormErrorState) {
          Fluttertoast.cancel();
          Fluttertoast.showToast(
            msg: 'Error while adding routine',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: ColorManager.error,
          );
          if (!mounted) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_loadingShown &&
                Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close dialog if open
            }
            _loadingShown = false;
          });
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
                      // Read-only tile + full-screen editor for routine name
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Routine Name'),
                        subtitle: Text(
                          routineNameController.text.trim().isEmpty
                              ? 'Add name'
                              : routineNameController.text.trim(),
                        ),
                        onTap: () async {
                          final v = await _promptText(
                            title: 'Routine Name',
                            initial: routineNameController.text,
                            keyboardType: TextInputType.name,
                            validator: (t) => (t == null || t.trim().isEmpty)
                                ? 'Required'
                                : null,
                          );
                          if (v != null) {
                            setState(() => routineNameController.text = v);
                            await _saveRoutineIncremental();
                          }
                        },
                        trailing: Icon(
                          routineNameController.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Description'),
                        subtitle: Text(
                          descriptionController.text.trim().isEmpty
                              ? 'Add description'
                              : descriptionController.text.trim(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () async {
                          final v = await _promptText(
                            title: 'Description',
                            initial: descriptionController.text,
                            minLines: 3,
                            maxLines: 5,
                            validator: (t) => (t == null || t.trim().isEmpty)
                                ? 'Required'
                                : null,
                          );
                          if (v != null) {
                            setState(() => descriptionController.text = v);
                            await _saveRoutineIncremental();
                          }
                        },
                        trailing: Icon(
                          descriptionController.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      const SizedBox.shrink(),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Duration (minutes)'),
                        subtitle: Text(
                          durationController.text.trim().isEmpty
                              ? 'Add duration'
                              : durationController.text.trim(),
                        ),
                        onTap: () async {
                          final v = await _promptText(
                            title: 'Duration (minutes)',
                            initial: durationController.text,
                            keyboardType: TextInputType.number,
                            validator: (t) {
                              final s = (t ?? '').trim();
                              if (s.isEmpty) return 'Required';
                              final n = int.tryParse(s);
                              if (n == null || n <= 0 || n > 1000) {
                                return 'Enter a valid number';
                              }
                              return null;
                            },
                          );
                          if (v != null) {
                            setState(() => durationController.text = v);
                            await _saveRoutineIncremental();
                          }
                        },
                        trailing: Icon(
                          durationController.text.trim().isEmpty
                              ? Icons.add
                              : Icons.edit,
                        ),
                      ),
                      SizedBox(
                        height: AppHeight.h10,
                      ),
                      SizedBox(height: AppHeight.h20),
                      if (widget.routine != null || _draftId != null) ...[
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
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                _exerciseItems[i].name.text.trim().isEmpty
                                    ? 'Exercise #${i + 1}'
                                    : _exerciseItems[i].name.text.trim(),
                              ),
                              subtitle: Text(
                                _exerciseItems[i]
                                        .description
                                        .text
                                        .trim()
                                        .isEmpty
                                    ? 'Tap to edit'
                                    : _exerciseItems[i].description.text.trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                                onPressed: () async {
                                  setState(() => _exerciseItems.removeAt(i));
                                  await _saveRoutineIncremental();
                                },
                                tooltip: 'Remove exercise',
                              ),
                              onTap: () async {
                                final changed =
                                    await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => ExerciseFormPage(
                                      data: _exerciseItems[i],
                                      index: i,
                                    ),
                                  ),
                                );
                                setState(() {});
                                if (changed == true) {
                                  await _saveRoutineIncremental();
                                }
                              },
                            ),
                          ),
                        SizedBox(height: AppHeight.h10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Exercise'),
                            onPressed: () async {
                              final item = ExerciseItemData();
                              _exerciseItems.add(item);
                              final changed =
                                  await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => ExerciseFormPage(
                                    data: item,
                                    index: _exerciseItems.length,
                                  ),
                                ),
                              );
                              if (changed == true) {
                                setState(() {});
                                await _saveRoutineIncremental();
                              } else {
                                // Discard new exercise when dialog closed without saving
                                setState(() {
                                  _exerciseItems.remove(item);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                      // Removed global Add/Update button; saves happen per-field
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
