import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/features/routine/domain/entities/routine.dart';

class RoutineDetailsHeader extends StatelessWidget {
  final Routine routine;

  const RoutineDetailsHeader({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      dense: true,
      contentPadding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      tileColor: ColorManager.white,
      title: Text(
        routine.name,
        style: const TextStyle(
          fontSize: FontSize.s20,
        ),
      ),
      subtitle: Column(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text("Duration: ${routine.duration} minutes"),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              routine.source,
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(routine.description),
          ),
        ],
      ),
      trailing: Text(
        routine.difficulty,
        style: const TextStyle(fontSize: FontSize.s14),
      ),
    );
  }
}
