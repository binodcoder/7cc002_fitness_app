import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class RoutineListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoutineListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppSlidableListTile(
      title: title,
      subtitle: subtitle,
      trailing: Text(trailing),
      isThreeLine: true,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
