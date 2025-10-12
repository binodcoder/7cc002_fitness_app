import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/routine/domain/entities/exercise.dart' as entity;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scheme = Theme.of(context).colorScheme;
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.46,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: scheme.surface,
        ),
        margin: EdgeInsets.all(size.width * 0.02),
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
  }
}
