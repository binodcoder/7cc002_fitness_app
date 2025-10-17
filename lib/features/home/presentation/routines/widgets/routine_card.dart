import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/home/domain/entities/routine.dart';
import 'package:fitness_app/features/home/domain/entities/exercise.dart' as ex;

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStart;
  final VoidCallback? onAddExercise;
  final bool showOwnerName;

  const RoutineCard({
    super.key,
    required this.routine,
    this.onEdit,
    this.onDelete,
    this.onStart,
    this.onAddExercise,
    this.showOwnerName = true,
  });

  Color _exerciseDiffColor(BuildContext context, ex.ExerciseDifficulty d) {
    switch (d) {
      case ex.ExerciseDifficulty.easy:
        return Colors.green.shade600;
      case ex.ExerciseDifficulty.medium:
        return Colors.orange.shade700;
      case ex.ExerciseDifficulty.hard:
        return Colors.red.shade700;
      case ex.ExerciseDifficulty.unknown:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onStart,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        if (showOwnerName && routine.source.isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person_outline,
                                  size: 14, color: ColorManager.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'By ${routine.source}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: ColorManager.grey),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 6),
                        if (routine.description.isNotEmpty)
                          Text(
                            routine.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: ColorManager.grey),
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _chip(context, Icons.timer_outlined,
                                '${routine.duration} min'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 12),
              // Exercises list
              if (routine.exercises.isNotEmpty) ...[
                Text(
                  'Exercises',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Column(
                  children: [
                    for (final exItem in routine.exercises)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          exItem.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      _exDiffPill(context, exItem.difficulty),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  if (exItem.description.isNotEmpty)
                                    Text(
                                      exItem.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: ColorManager.grey),
                                    ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      if (exItem.targetMuscleGroups.isNotEmpty)
                                        _chip(context, Icons.insights_outlined,
                                            exItem.targetMuscleGroups),
                                      if (exItem.equipment.isNotEmpty)
                                        _chip(context, Icons.handyman_outlined,
                                            exItem.equipment),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 4),
              ],
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onStart != null)
                    TextButton.icon(
                      onPressed: onStart,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start'),
                    ),
                  if (onAddExercise != null)
                    TextButton.icon(
                      onPressed: onAddExercise,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                  if (onEdit != null)
                    IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      tooltip: 'Delete',
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                      onPressed: onDelete,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: ColorManager.grey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: ColorManager.grey)),
        ],
      ),
    );
  }

  Widget _exDiffPill(BuildContext context, ex.ExerciseDifficulty d) {
    final color = _exerciseDiffColor(context, d);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(d.label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
