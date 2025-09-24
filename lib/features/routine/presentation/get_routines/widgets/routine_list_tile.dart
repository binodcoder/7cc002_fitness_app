import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';

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
    final size = MediaQuery.of(context).size;
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.46,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorManager.white,
        ),
        margin: EdgeInsets.only(
          top: size.width * 0.04,
          left: size.width * 0.02,
          right: size.width * 0.02,
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text(trailing),
          isThreeLine: true,
        ),
      ),
    );
  }
}

