import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';

class WalkMediaDetailsBody extends StatelessWidget {
  final WalkMedia walkMedia;

  const WalkMediaDetailsBody({
    super.key,
    required this.walkMedia,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = walkMedia.mediaUrl.startsWith('http');
    bool isImageUrl(String url) {
      final p = url.toLowerCase();
      return p.endsWith('.jpg') ||
          p.endsWith('.jpeg') ||
          p.endsWith('.png') ||
          p.endsWith('.gif') ||
          p.endsWith('.webp');
    }

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppHeight.h10),
          if (isNetwork && isImageUrl(walkMedia.mediaUrl))
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  walkMedia.mediaUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            )
          else ...[
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.videocam, size: 60),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(walkMedia.mediaUrl);
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to open media')),
                  );
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Media'),
            ),
          ],
          SizedBox(height: AppHeight.h20),
          Text(
            'Uploaded by user ${walkMedia.userId}',
            style: const TextStyle(
                fontSize: FontSize.s14, color: ColorManager.grey),
          ),
          SizedBox(height: AppHeight.h10),
          Text(
            walkMedia.mediaUrl,
            style: const TextStyle(fontSize: FontSize.s12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
