import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class AppointmentEventTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AppointmentEventTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.onEdit,
    this.onDelete,
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
