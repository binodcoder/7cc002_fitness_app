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
import 'package:fitness_app/features/routine/domain/entities/exercise.dart'
    as entity;

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
  final List<_ExerciseItemData> _exerciseItems = [];
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
        builder: (_) => _TextEditDialogPage(
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
                                    builder: (_) => _ExerciseEditPage(
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
                              final item = _ExerciseItemData();
                              _exerciseItems.add(item);
                              final changed =
                                  await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => _ExerciseEditPage(
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
    d.difficulty.text = ex.difficulty.name;
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
      difficulty: entity.ExerciseDifficultyX.fromString(difficulty.text.trim()),
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
                  icon:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
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
            DropdownButtonFormField<entity.ExerciseDifficulty>(
              initialValue: (entity.ExerciseDifficultyX.fromString(
                          data.difficulty.text) ==
                      entity.ExerciseDifficulty.unknown
                  ? null
                  : entity.ExerciseDifficultyX.fromString(
                      data.difficulty.text)),
              decoration: const InputDecoration(
                labelText: 'Difficulty',
              ),
              items: const [
                entity.ExerciseDifficulty.easy,
                entity.ExerciseDifficulty.medium,
                entity.ExerciseDifficulty.hard,
              ]
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d.label),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  data.difficulty.text = val.name; // store lowercase
                }
              },
              validator: (val) => val == null ? '*Required' : null,
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

class _TextEditDialogPage extends StatefulWidget {
  final String title;
  final String initial;
  final TextInputType keyboardType;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TextEditDialogPage({
    required this.title,
    required this.initial,
    this.keyboardType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<_TextEditDialogPage> createState() => _TextEditDialogPageState();
}

class _TextEditDialogPageState extends State<_TextEditDialogPage> {
  late final TextEditingController _ctrl =
      TextEditingController(text: widget.initial);
  String? _error;

  void _save() {
    final err = widget.validator?.call(_ctrl.text);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    Navigator.of(context).pop(_ctrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final fc = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(foregroundColor: fc),
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        title: Text(widget.title),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppWidth.w30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _ctrl,
                keyboardType: widget.keyboardType,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: widget.title,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  errorText: _error,
                ),
                onSubmitted: (_) => _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyEditPage extends StatefulWidget {
  final String initial; // expects lowercase name or empty
  const _DifficultyEditPage({required this.initial});

  @override
  State<_DifficultyEditPage> createState() => _DifficultyEditPageState();
}

class _DifficultyEditPageState extends State<_DifficultyEditPage> {
  late entity.ExerciseDifficulty? _selected =
      entity.ExerciseDifficultyX.fromString(widget.initial) ==
              entity.ExerciseDifficulty.unknown
          ? null
          : entity.ExerciseDifficultyX.fromString(widget.initial);

  @override
  Widget build(BuildContext context) {
    final fc = Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: TextButton.styleFrom(foregroundColor: fc),
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Cancel'),
        ),
        title: const Text('Difficulty'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: fc),
            onPressed: () =>
                Navigator.of(context).pop<String>(_selected?.name ?? ''),
            child: const Text('Save'),
          )
        ],
      ),
      body: ListView(
        children: [
          RadioListTile<entity.ExerciseDifficulty?>(
            value: null,
            groupValue: _selected,
            title: const Text('Clear'),
            onChanged: (v) => setState(() => _selected = v),
          ),
          for (final d in const [
            entity.ExerciseDifficulty.easy,
            entity.ExerciseDifficulty.medium,
            entity.ExerciseDifficulty.hard,
          ])
            RadioListTile<entity.ExerciseDifficulty?>(
              value: d,
              groupValue: _selected,
              title: Text(d.label),
              onChanged: (v) => setState(() => _selected = v),
            ),
        ],
      ),
    );
  }
}

class _ExerciseEditPage extends StatefulWidget {
  final _ExerciseItemData data;
  final int index;
  const _ExerciseEditPage({required this.data, required this.index});

  @override
  State<_ExerciseEditPage> createState() => _ExerciseEditPageState();
}

class _ExerciseEditPageState extends State<_ExerciseEditPage> {
  bool _dirty = false;
  Future<void> _editText({
    required String title,
    required TextEditingController target,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) async {
    final v = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _TextEditDialogPage(
          title: title,
          initial: target.text,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          validator: validator,
        ),
      ),
    );
    if (v != null) {
      setState(() {
        target.text = v;
        _dirty = true;
      });
    }
  }

  Future<void> _editDifficulty() async {
    final v = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            _DifficultyEditPage(initial: widget.data.difficulty.text),
      ),
    );
    if (v != null) {
      setState(() {
        widget.data.difficulty.text = v;
        _dirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop<bool>(_dirty);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Exercise #${widget.index}'),
          ),
          body: ListView(
            padding:
                EdgeInsets.symmetric(horizontal: AppWidth.w30, vertical: 12),
            children: [
              ListTile(
                title: const Text('Name'),
                subtitle: Text(widget.data.name.text.trim().isEmpty
                    ? 'Add name'
                    : widget.data.name.text.trim()),
                trailing: Icon(
                  widget.data.name.text.trim().isEmpty ? Icons.add : Icons.edit,
                ),
                onTap: () => _editText(title: 'Name', target: widget.data.name),
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Description'),
                subtitle: Text(
                  widget.data.description.text.trim().isEmpty
                      ? 'Add description'
                      : widget.data.description.text.trim(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(
                  widget.data.description.text.trim().isEmpty
                      ? Icons.add
                      : Icons.edit,
                ),
                onTap: () => _editText(
                  title: 'Description',
                  target: widget.data.description,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Target Muscle Groups'),
                subtitle: Text(
                    widget.data.targetMuscleGroups.text.trim().isEmpty
                        ? 'Add target muscle groups'
                        : widget.data.targetMuscleGroups.text.trim()),
                trailing: Icon(
                  widget.data.targetMuscleGroups.text.trim().isEmpty
                      ? Icons.add
                      : Icons.edit,
                ),
                onTap: () => _editText(
                  title: 'Target Muscle Groups',
                  target: widget.data.targetMuscleGroups,
                ),
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Difficulty'),
                subtitle: Text(widget.data.difficulty.text.isEmpty
                    ? 'Select'
                    : entity.ExerciseDifficultyX.fromString(
                            widget.data.difficulty.text)
                        .label),
                trailing: Icon(
                  widget.data.difficulty.text.isEmpty ? Icons.add : Icons.edit,
                ),
                onTap: _editDifficulty,
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Equipment'),
                subtitle: Text(widget.data.equipment.text.trim().isEmpty
                    ? 'Add equipment'
                    : widget.data.equipment.text.trim()),
                trailing: Icon(
                  widget.data.equipment.text.trim().isEmpty
                      ? Icons.add
                      : Icons.edit,
                ),
                onTap: () => _editText(
                    title: 'Equipment', target: widget.data.equipment),
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Image URL'),
                subtitle: Text(widget.data.imageUrl.text.trim().isEmpty
                    ? 'Add image URL'
                    : widget.data.imageUrl.text.trim()),
                trailing: Icon(
                  widget.data.imageUrl.text.trim().isEmpty
                      ? Icons.add
                      : Icons.edit,
                ),
                onTap: () => _editText(
                  title: 'Image URL',
                  target: widget.data.imageUrl,
                  keyboardType: TextInputType.url,
                ),
              ),
              const Divider(height: 8),
              ListTile(
                title: const Text('Video URL'),
                subtitle: Text(widget.data.videoUrl.text.trim().isEmpty
                    ? 'Add video URL'
                    : widget.data.videoUrl.text.trim()),
                trailing: Icon(
                  widget.data.videoUrl.text.trim().isEmpty
                      ? Icons.add
                      : Icons.edit,
                ),
                onTap: () => _editText(
                  title: 'Video URL',
                  target: widget.data.videoUrl,
                  keyboardType: TextInputType.url,
                ),
              ),
            ],
          ),
        ));
  }
}
