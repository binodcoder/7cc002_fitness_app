import 'package:fitness_app/features/home/domain/entities/exercise.dart';
import 'package:flutter/material.dart';

class DifficultyEditPage extends StatefulWidget {
  final String initial; // expects lowercase name or empty
  const DifficultyEditPage({super.key, required this.initial});

  @override
  State<DifficultyEditPage> createState() => _DifficultyEditPageState();
}

class _DifficultyEditPageState extends State<DifficultyEditPage> {
  late ExerciseDifficulty? _selected =
      ExerciseDifficultyX.fromString(widget.initial) ==
              ExerciseDifficulty.unknown
          ? null
          : ExerciseDifficultyX.fromString(widget.initial);

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
          RadioListTile<ExerciseDifficulty?>(
            value: null,
            groupValue: _selected,
            title: const Text('Clear'),
            onChanged: (v) => setState(() => _selected = v),
          ),
          for (final d in const [
            ExerciseDifficulty.easy,
            ExerciseDifficulty.medium,
            ExerciseDifficulty.hard,
          ])
            RadioListTile<ExerciseDifficulty?>(
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
