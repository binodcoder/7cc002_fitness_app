import 'package:flutter/material.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class AppointmentEventTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? startTime;
  final String? endTime;
  final String? trainerName;
  final String? clientName;
  final String? remarks;
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
    this.trainerName,
    this.clientName,
    this.remarks,
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

    // Build a richer details widget when we have extra info
    final details = _buildDetailsWidget(
      context: context,
      startHM: startHM,
      endHM: endHM,
      trainer: trainerName,
      client: clientName,
      remarks: remarks,
    );
    return AppSlidableListTile(
      title: title,
      titleStyle: theme.textTheme.titleMedium,
      subtitle: details == null ? computedSubtitle : null,
      subtitleWidget: details,
      subtitleStyle: theme.textTheme.bodySmall,
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

  Widget? _buildDetailsWidget({
    required BuildContext context,
    String? startHM,
    String? endHM,
    String? trainer,
    String? client,
    String? remarks,
  }) {
    final rows = <Widget>[];
    final textStyle = Theme.of(context).textTheme.bodySmall;

    final line = (IconData icon, String text) => Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 14, color: Theme.of(context).hintColor),
              const SizedBox(width: 6),
              Expanded(child: Text(text, style: textStyle)),
            ],
          ),
        );

    final timeText = _buildSubtitle(startHM, endHM);
    if (timeText != null && timeText.isNotEmpty) {
      rows.add(line(Icons.schedule, timeText));
    }
    if (trainer != null && trainer.trim().isNotEmpty) {
      rows.add(line(Icons.person_outline, 'Trainer: ${trainer.trim()}'));
    }
    if (client != null && client.trim().isNotEmpty) {
      rows.add(line(Icons.account_circle_outlined, 'Client: ${client.trim()}'));
    }
    if (remarks != null && remarks.trim().isNotEmpty) {
      rows.add(line(Icons.notes_outlined, remarks.trim()));
    }

    if (rows.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
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
