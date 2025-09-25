import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class WalkListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isJoined;
  final VoidCallback onTap;
  final VoidCallback onJoinTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WalkListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isJoined,
    required this.onTap,
    required this.onJoinTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppSlidableListTile(
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      trailing: TextButton(
        onPressed: onJoinTap,
        child: Text(isJoined ? 'Leave' : 'Join'),
      ),
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
