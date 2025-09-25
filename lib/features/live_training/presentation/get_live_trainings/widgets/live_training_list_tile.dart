import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class LiveTrainingListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LiveTrainingListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppSlidableListTile(
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
