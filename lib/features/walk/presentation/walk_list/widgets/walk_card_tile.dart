import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fitness_app/core/widgets/custom_button.dart';
import 'package:fitness_app/features/walk/presentation/walk_form/widgets/route_preview.dart';

class WalkCardTile extends StatelessWidget {
  final String routeData;
  final String startLocation;
  final DateTime date;
  final String startTime; // HH:mm or similar
  final bool isJoined;
  final int participantCount;
  final VoidCallback onTap;
  final VoidCallback onJoinTap;
  final VoidCallback?
      onEdit; // reserved if needed by slidable actions in future

  const WalkCardTile({
    super.key,
    required this.routeData,
    required this.startLocation,
    required this.date,
    required this.startTime,
    required this.isJoined,
    required this.participantCount,
    required this.onTap,
    required this.onJoinTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final parsed = _parseRoute(routeData);
    final routeTitle = _buildRouteTitle(parsed, startLocation);

    final dt = _formatDateTime(date, startTime);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map preview
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: RoutePreview(
                routeJson: parsed?.rawJson ?? routeData,
                height: 160,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routeTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(builder: (context, constraints) {
                    final double buttonWidth =
                        constraints.maxWidth < 360 ? 84 : 96;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _ChipIconText(
                                icon: Icons.event,
                                text: dt.dateLabel,
                                color: scheme.primary,
                                background: scheme.primary.withAlpha(25),
                              ),
                              _ChipIconText(
                                icon: Icons.schedule,
                                text: dt.timeLabel,
                                color: scheme.secondary,
                                background: scheme.secondary.withAlpha(25),
                              ),
                              _ChipIconText(
                                icon: Icons.group,
                                text: _peopleLabel(participantCount),
                                color: scheme.tertiary,
                                background: scheme.tertiary.withAlpha(25),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: buttonWidth,
                          height: 36,
                          child: CustomButton(
                            onPressed: onJoinTap,
                            borderRadius: BorderRadius.circular(18),
                            child: Text(
                              isJoined ? 'Leave' : 'Join',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _RouteParsed? _parseRoute(String data) {
    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return _RouteParsed(
        rawJson: data,
        startName: (map['start'] as Map<String, dynamic>?)?['name']?.toString(),
        endName: (map['end'] as Map<String, dynamic>?)?['name']?.toString(),
      );
    } catch (_) {
      return null;
    }
  }

  String _buildRouteTitle(_RouteParsed? parsed, String startLocation) {
    if (parsed != null) {
      final s = parsed.startName;
      final e = parsed.endName;
      if (s != null && e != null && s.isNotEmpty && e.isNotEmpty) {
        return '$s → $e';
      }
      if (s != null && s.isNotEmpty) return s;
      if (e != null && e.isNotEmpty) return e;
    }
    return startLocation;
  }

  _NiceDateTime _formatDateTime(DateTime date, String startTime) {
    // Parse HH:mm if possible
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

  static String _peopleLabel(int count) {
    if (count <= 0) return '0 joined';
    if (count == 1) return '1 joined';
    return '$count joined';
  }
}

class _ChipIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color background;

  const _ChipIconText({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
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

class _RouteParsed {
  final String rawJson;
  final String? startName;
  final String? endName;

  _RouteParsed({required this.rawJson, this.startName, this.endName});
}

class _NiceDateTime {
  final String dateLabel;
  final String timeLabel;

  _NiceDateTime({required this.dateLabel, required this.timeLabel});
}
