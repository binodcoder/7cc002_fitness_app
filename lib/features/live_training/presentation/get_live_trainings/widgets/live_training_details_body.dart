import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/live_training/domain/entities/live_training.dart';

class LiveTrainingDetailsBody extends StatelessWidget {
  final LiveTraining liveTraining;

  const LiveTrainingDetailsBody({
    super.key,
    required this.liveTraining,
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
              DateFormat("yMd").format(liveTraining.trainingDate),
              style: const TextStyle(fontSize: FontSize.s20),
            ),
            subtitle: Text(
              liveTraining.startTime,
              style: const TextStyle(fontSize: FontSize.s14),
            ),
            trailing: const Text(
              "code: test",
              style: TextStyle(fontSize: FontSize.s14),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              liveTraining.description,
              style: const TextStyle(fontSize: FontSize.s14),
            ),
          ),
          SizedBox(height: AppHeight.h20),
          if ((liveTraining.streamUrl ?? '').isNotEmpty) ...[
            SizedBox(height: AppHeight.h10),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(liveTraining.streamUrl!.trim());
                final ok = await launchUrl(url,
                    mode: LaunchMode.externalApplication);
                if (!ok) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to open link')),
                  );
                }
              },
              icon: const Icon(Icons.live_tv),
              label: const Text('Join Stream'),
            ),
          ],
          SizedBox(height: AppHeight.h20),
        ],
      ),
    );
  }
}
