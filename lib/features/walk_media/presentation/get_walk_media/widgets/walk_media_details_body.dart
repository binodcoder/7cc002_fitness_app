import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/walk_media/data/models/walk_media_model.dart';

class WalkMediaDetailsBody extends StatelessWidget {
  final WalkMediaModel walkMediaModel;

  const WalkMediaDetailsBody({
    super.key,
    required this.walkMediaModel,
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
              walkMediaModel.mediaUrl,
              style: const TextStyle(fontSize: FontSize.s20),
            ),
            subtitle: Text(
              walkMediaModel.userId.toString(),
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

