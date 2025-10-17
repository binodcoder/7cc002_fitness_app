import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/walk/domain/entities/walk.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/widgets/route_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/bloc/walk_media_bloc.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/bloc/walk_media_state.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/ui/walk_media_details.dart';
import 'package:fitness_app/features/walk/presentation/walk_media/walk_media_list/ui/walk_media.dart';
import 'package:fitness_app/features/walk/domain/entities/walk_media.dart';

class WalkDetailsBody extends StatelessWidget {
  final Walk walk;
  final List<Participant> participants;
  final String proposerName;
  final int? walkId;

  const WalkDetailsBody({
    super.key,
    required this.walk,
    required this.participants,
    required this.proposerName,
    this.walkId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final dt = _formatDateTime(walk.date, walk.startTime);
    final title =
        _routeTitleFromJsonOrFallback(walk.routeData, walk.startLocation);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photos header + See all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Photos', style: theme.textTheme.titleMedium),
              if ((walk.id ?? 0) != 0)
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (_) => WalkMediaPage(walkId: walk.id!),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: const Text('See all photos'),
                ),
            ],
          ),
          // Media banner
          _MediaBanner(walkId: walkId),
          const SizedBox(height: 16),

          // Map preview
          RoutePreview(routeJson: walk.routeData, height: 200),
          const SizedBox(height: 16),

          // Title
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),

          // Chips row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, Icons.event, dt.dateLabel, scheme.primary),
              _chip(context, Icons.schedule, dt.timeLabel, scheme.secondary),
              _chip(
                  context, Icons.pin_drop, walk.startLocation, scheme.tertiary),
            ],
          ),

          const SizedBox(height: 24),

          // Proposed by
          Row(
            children: [
              const Icon(Icons.person, color: ColorManager.primary),
              const SizedBox(width: 8),
              Text('Proposed by $proposerName',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: theme.dividerColor.withOpacity(0.3)),
          const SizedBox(height: 16),

          // Participants section
          Text('Participants (${participants.length})',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (participants.isEmpty)
            Text('No one has joined yet. Be the first!',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey))
          else
            _ParticipantsList(participants: participants),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _routeTitleFromJsonOrFallback(String data, String fallback) {
    try {
      final m = jsonDecode(data) as Map<String, dynamic>;
      final s = (m['start'] as Map<String, dynamic>?)?['name']?.toString();
      final e = (m['end'] as Map<String, dynamic>?)?['name']?.toString();
      if (s != null && e != null && s.isNotEmpty && e.isNotEmpty) {
        return '$s → $e';
      }
      if (s != null && s.isNotEmpty) return s;
      if (e != null && e.isNotEmpty) return e;
    } catch (_) {}
    return fallback;
  }

  _NiceDateTime _formatDateTime(DateTime date, String startTime) {
    TimeOfDay? t;
    try {
      final parts = startTime.split(':');
      if (parts.length >= 2) {
        t = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    } catch (_) {}

    final now = DateTime.now();
    final justDate = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    String dateLabel;
    if (justDate == today) {
      dateLabel = 'Today';
    } else if (justDate == tomorrow) {
      dateLabel = 'Tomorrow';
    } else {
      dateLabel = DateFormat('EEE, MMM d').format(date);
    }

    final timeLabel = t != null
        ? _formatTime(t)
        : DateFormat('h:mm a')
            .format(DateTime(date.year, date.month, date.day));

    return _NiceDateTime(dateLabel: dateLabel, timeLabel: timeLabel);
  }

  String _formatTime(TimeOfDay t) {
    final dt = DateTime(0, 1, 1, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  Widget _chip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _ParticipantsList extends StatelessWidget {
  final List<Participant> participants;
  const _ParticipantsList({required this.participants});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: participants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final p = participants[index];
              final initials = _initials(p.name);
              return Column(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      initials,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 70,
                    child: Text(
                      p.name.isEmpty ? 'User #${p.id}' : p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class _NiceDateTime {
  final String dateLabel;
  final String timeLabel;

  _NiceDateTime({required this.dateLabel, required this.timeLabel});
}

class _MediaBanner extends StatelessWidget {
  final int? walkId;
  const _MediaBanner({this.walkId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalkMediaBloc, WalkMediaState>(
      builder: (context, state) {
        if (state is WalkMediaLoadingState || state is WalkMediaInitialState) {
          return _placeholder();
        }
        if (state is WalkMediaLoadedSuccessState) {
          final media = state
              .walkMediaList; // show all; let Image.network fail gracefully
          if (media.isNotEmpty) return _buildMediaList(context, media);
          return _emptyBanner(context);
        }
        if (state is WalkMediaErrorState) return _emptyBanner(context);
        return const SizedBox.shrink();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _emptyBanner(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_outlined),
            SizedBox(width: 8),
            Text('No photos yet'),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<String> urls) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final url = urls[index];
          return _BannerItem(
            imageUrl: url,
            onTap: () {
              final media = WalkMedia(
                walkId: walkId ?? 0,
                userId: 0,
                mediaUrl: url,
              );
              _openDetails(context, media);
            },
          );
        },
      ),
    );
  }

  Widget _buildMediaList(BuildContext context, List<WalkMedia> media) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: media.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final m = media[index];
          return _BannerItem(
            imageUrl: m.mediaUrl,
            onTap: () => _openDetails(context, m),
          );
        },
      ),
    );
  }

  void _openDetails(BuildContext context, WalkMedia media) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => WalkMediaDetailsPage(walkMedia: media),
        fullscreenDialog: true,
      ),
    );
  }

  static bool _isImageUrl(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.jpg') ||
        u.endsWith('.jpeg') ||
        u.endsWith('.png') ||
        u.endsWith('.gif') ||
        u.endsWith('.webp');
  }

  // Card child
}

class _BannerItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _BannerItem({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: InkWell(
          onTap: onTap,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
      ),
    );
  }
}
