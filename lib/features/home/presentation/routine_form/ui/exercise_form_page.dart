import 'package:fitness_app/core/theme/tokens/layout_tokens.dart';
import 'package:fitness_app/features/home/domain/entities/exercise.dart';
import 'package:fitness_app/features/home/presentation/routine_form/widgets/difficulty_edit_dialog.dart';
import 'package:fitness_app/features/home/presentation/routine_form/widgets/exercise_item_data.dart';
import 'package:fitness_app/features/home/presentation/routine_form/widgets/text_edit_dialog.dart';
import 'package:flutter/material.dart';

class ExerciseFormPage extends StatefulWidget {
  final ExerciseItemData data;
  final int index;
  const ExerciseFormPage({super.key, required this.data, required this.index});

  @override
  State<ExerciseFormPage> createState() => _ExerciseFormPageState();
}

class _ExerciseFormPageState extends State<ExerciseFormPage> {
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
        builder: (_) => TextEditDialogPage(
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
            DifficultyEditPage(initial: widget.data.difficulty.text),
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
                    : ExerciseDifficultyX.fromString(
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
