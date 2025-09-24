import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';

class WalkDetailsBody extends StatelessWidget {
  final Walk walk;

  const WalkDetailsBody({
    super.key,
    required this.walk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          SizedBox(height: AppHeight.h10),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            tileColor: ColorManager.white,
            title: Text(
              walk.startLocation,
              style: const TextStyle(fontSize: FontSize.s20),
            ),
            subtitle: Text(
              walk.date.toString(),
              style: const TextStyle(fontSize: FontSize.s14),
            ),
          ),
          SizedBox(height: AppHeight.h20),
          SizedBox(height: AppHeight.h20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '',
              style: TextStyle(fontSize: FontSize.s12),
            ),
          )
        ],
      ),
    );
  }
}
