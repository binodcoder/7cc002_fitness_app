import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

class RoutineListTile extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final int durationMinutes;
  final String? source;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoutineListTile({
    super.key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.durationMinutes,
    this.source,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color _difficultyColor(BuildContext context) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green.shade600;
      case 'medium':
        return Colors.orange.shade700;
      case 'hard':
        return Colors.red.shade700;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffColor = _difficultyColor(context);
    final sub = (source != null && source!.isNotEmpty)
        ? '$description • $source'
        : description;
    return AppSlidableListTile(
      title: title,
      subtitle: sub,
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 140),
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
                  difficulty,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: diffColor, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 16, color: ColorManager.grey),
                  const SizedBox(width: 4),
                  Text(
                    '$durationMinutes min',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: ColorManager.grey),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isThreeLine: true,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
