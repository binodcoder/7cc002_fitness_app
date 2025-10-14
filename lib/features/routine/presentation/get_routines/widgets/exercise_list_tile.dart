import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';
import 'package:fitness_app/features/routine/domain/entities/exercise.dart'
    as entity;

class ExerciseListTile extends StatelessWidget {
  final entity.Exercise exerciseModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExerciseListTile({
    super.key,
    required this.exerciseModel,
    required this.onEdit,
    required this.onDelete,
  });

  Color _difficultyColor(BuildContext context) {
    switch (exerciseModel.difficulty) {
      case entity.ExerciseDifficulty.easy:
        return Colors.green.shade600;
      case entity.ExerciseDifficulty.medium:
        return Colors.orange.shade700;
      case entity.ExerciseDifficulty.hard:
        return Colors.red.shade700;
      case entity.ExerciseDifficulty.unknown:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffColor = _difficultyColor(context);
    // As requested: do not use a leading icon or image
    return AppSlidableListTile(
      title: exerciseModel.name,
      titleStyle: Theme.of(context).textTheme.titleMedium,
      subtitle:
          '${exerciseModel.equipment} • ${exerciseModel.description}'.trim(),
      subtitleStyle: Theme.of(context).textTheme.bodySmall,
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 160),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: diffColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: diffColor.withOpacity(0.3)),
                ),
                child: Text(
                  exerciseModel.difficulty.label,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: diffColor, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                exerciseModel.targetMuscleGroups,
                style: const TextStyle(color: ColorManager.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
      isThreeLine: true,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
