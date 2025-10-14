import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class AppointmentEventTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? startTime;
  final String? endTime;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? trailing;
  final String? editLabel;
  final String? deleteLabel;
  final IconData? editIcon;
  final IconData? deleteIcon;
  final Color? editActionColor;
  final Color? deleteActionColor;
  final Color? actionForegroundColor;

  const AppointmentEventTile({
    super.key,
    required this.title,
    this.subtitle,
    this.startTime,
    this.endTime,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.trailing,
    this.editLabel,
    this.deleteLabel,
    this.editIcon,
    this.deleteIcon,
    this.editActionColor,
    this.deleteActionColor,
    this.actionForegroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startHM = _formatHM(startTime);
    final endHM = _formatHM(endTime);
    final computedSubtitle = subtitle ?? _buildSubtitle(startHM, endHM);
    return AppSlidableListTile(
      title: title,
      titleStyle: theme.textTheme.titleMedium,
      subtitle: computedSubtitle,
      subtitleStyle: theme.textTheme.bodySmall,
      leading: _TimeBadge(time: startHM),
      trailing: trailing,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
      editLabel: editLabel,
      deleteLabel: deleteLabel,
      editIcon: editIcon,
      deleteIcon: deleteIcon,
      editActionColor: editActionColor,
      deleteActionColor: deleteActionColor,
      actionForegroundColor: actionForegroundColor,
    );
  }

  String? _buildSubtitle(String? start, String? end) {
    if (start == null && end == null) return null;
    if (start != null && end != null) return '$start – $end';
    return start ?? end;
  }

  // Normalize to HH:mm if input like HH:mm:ss or H:m or HH:mm
  String? _formatHM(String? input) {
    if (input == null) return null;
    final t = input.trim();
    if (t.isEmpty) return null;
    final re = RegExp(r'^(\d{1,2})(?::(\d{1,2}))?(?::(\d{1,2}))?$');
    final m = re.firstMatch(t);
    if (m == null) return t; // fallback as-is
    int h = int.tryParse(m.group(1) ?? '') ?? 0;
    int mnt = int.tryParse(m.group(2) ?? '') ?? 0;
    // seconds ignored
    h = h.clamp(0, 23);
    mnt = mnt.clamp(0, 59);
    final hh = h.toString().padLeft(2, '0');
    final mm = mnt.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _TimeBadge extends StatelessWidget {
  final String? time;
  const _TimeBadge({this.time});

  @override
  Widget build(BuildContext context) {
    if (time == null || time!.trim().isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.primary.withOpacity(0.25)),
      ),
      child: Text(
        time!,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
