import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';
import 'package:fitness_app/core/widgets/custom_button.dart';

class LiveTrainingListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final DateTime trainingDate;
  final String startTime;
  final String endTime;
  final String? streamUrl;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? trailing;

  const LiveTrainingListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trainingDate,
    required this.startTime,
    required this.endTime,
    this.streamUrl,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.trailing,
  });

  @override
  State<LiveTrainingListTile> createState() => _LiveTrainingListTileState();
}

class _LiveTrainingListTileState extends State<LiveTrainingListTile> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final dateLabel = DateFormat('EEE, MMM d').format(widget.trainingDate);

    bool isJoinActive() {
      try {
        List<int> parseParts(String t) {
          final parts = t.split(':');
          final h = int.parse(parts[0]);
          final m = parts.length > 1 ? int.parse(parts[1]) : 0;
          final s = parts.length > 2 ? int.parse(parts[2]) : 0;
          return [h, m, s];
        }

        final sp = parseParts(widget.startTime);
        final ep = parseParts(widget.endTime);
        final start = DateTime(
            widget.trainingDate.year,
            widget.trainingDate.month,
            widget.trainingDate.day,
            sp[0],
            sp[1],
            sp[2]);
        final end = DateTime(
            widget.trainingDate.year,
            widget.trainingDate.month,
            widget.trainingDate.day,
            ep[0],
            ep[1],
            ep[2]);
        final now = DateTime.now();
        return now.isAfter(start) && now.isBefore(end) ||
            now.isAtSameMomentAs(start) ||
            now.isAtSameMomentAs(end);
      } catch (_) {
        return false;
      }
    }

    Duration? _timeUntilStart() {
      try {
        final parts = widget.startTime.split(':');
        final start = DateTime(
          widget.trainingDate.year,
          widget.trainingDate.month,
          widget.trainingDate.day,
          int.parse(parts[0]),
          parts.length > 1 ? int.parse(parts[1]) : 0,
          parts.length > 2 ? int.parse(parts[2]) : 0,
        );
        final diff = start.difference(DateTime.now());
        return diff.isNegative ? Duration.zero : diff;
      } catch (_) {
        return null;
      }
    }

    Duration? _timeUntilEnd() {
      try {
        final parts = widget.endTime.split(':');
        final end = DateTime(
          widget.trainingDate.year,
          widget.trainingDate.month,
          widget.trainingDate.day,
          int.parse(parts[0]),
          parts.length > 1 ? int.parse(parts[1]) : 0,
          parts.length > 2 ? int.parse(parts[2]) : 0,
        );
        final diff = end.difference(DateTime.now());
        return diff.isNegative ? Duration.zero : diff;
      } catch (_) {
        return null;
      }
    }

    String _fmt(Duration d) {
      final dDays = d.inDays;
      final dHours = d.inHours % 24;
      final dMins = d.inMinutes % 60;
      final dSecs = d.inSeconds % 60;
      if (dDays > 0) {
        return '${dDays}d ${dHours}h';
      } else if (dHours > 0) {
        return '${dHours}h ${dMins}m';
      } else if (dMins > 0) {
        return '${dMins}m ${dSecs}s';
      } else {
        return '${dSecs}s';
      }
    }

    bool _isEnded() {
      try {
        final parts = widget.endTime.split(':');
        final end = DateTime(
          widget.trainingDate.year,
          widget.trainingDate.month,
          widget.trainingDate.day,
          int.parse(parts[0]),
          parts.length > 1 ? int.parse(parts[1]) : 0,
          parts.length > 2 ? int.parse(parts[2]) : 0,
        );
        return DateTime.now().isAfter(end);
      } catch (_) {
        return false;
      }
    }

    final active = isJoinActive();
    final ended = _isEnded();
    final beforeStart = !active && !ended;

    final canJoinNow = (widget.streamUrl ?? '').trim().isNotEmpty && active;
    final dur = active
        ? _timeUntilEnd()
        : beforeStart
            ? _timeUntilStart()
            : null;
    String statusText;
    Color statusColor;
    if (active) {
      statusText = dur == null ? 'Live' : 'Live · ${_fmt(dur)} left';
      statusColor = scheme.error;
    } else if (beforeStart) {
      statusText = dur == null ? '' : 'Starts in ${_fmt(dur)}';
      statusColor = scheme.tertiary;
    } else {
      statusText = 'Ended';
      statusColor = scheme.onSurfaceVariant;
    }
    final statusBg = statusColor.withAlpha(25);

    return AppSlidableListTile(
      title: widget.title,
      subtitleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips row for date and time
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _ChipIconText(
                icon: Icons.event,
                text: dateLabel,
                color: scheme.primary,
                background: scheme.primary.withAlpha(25),
              ),
              _ChipIconText(
                icon: Icons.schedule,
                text: widget.startTime,
                color: scheme.secondary,
                background: scheme.secondary.withAlpha(25),
              ),
              if (statusText.isNotEmpty)
                _ChipIconText(
                  icon: beforeStart ? Icons.timer_outlined : Icons.circle,
                  text: statusText,
                  color: statusColor,
                  background: statusBg,
                ),
            ],
          ),
          if (widget.subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall,
            ),
          ],
          if ((widget.streamUrl ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  height: 36,
                  width: 110,
                  child: CustomButton(
                    onPressed: canJoinNow
                        ? () async {
                            final url = Uri.parse(widget.streamUrl!.trim());
                            if (!await launchUrl(url,
                                mode: LaunchMode.externalApplication)) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to open link')),
                              );
                            }
                          }
                        : null,
                    borderRadius: BorderRadius.circular(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.live_tv,
                            size: 18, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'Join',
                          style: textTheme.labelLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      trailing:
          widget.trailing ?? Text('code: test', style: textTheme.bodySmall),
      onTap: widget.onTap,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
      isThreeLine: true,
    );
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
          Text(
            text,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
