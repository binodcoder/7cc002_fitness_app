import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/localization/app_strings.dart';

class AppSlidableListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Widget? leading;
  final Widget? trailing;
  final bool isThreeLine;
  final EdgeInsetsGeometry? margin;
  final double actionExtentRatio;
  final String? editLabel;
  final String? deleteLabel;
  final IconData? editIcon;
  final IconData? deleteIcon;
  final Color? editActionColor;
  final Color? deleteActionColor;
  final Color? actionForegroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextScaler? titleScaler;

  const AppSlidableListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.leading,
    this.trailing,
    this.isThreeLine = false,
    this.margin,
    this.actionExtentRatio = 0.46,
    this.editLabel,
    this.deleteLabel,
    this.editIcon,
    this.deleteIcon,
    this.editActionColor,
    this.deleteActionColor,
    this.actionForegroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.titleScaler,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hasActions = onEdit != null || onDelete != null;
    final content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.white,
      ),
      margin: margin ?? EdgeInsets.all(size.width * 0.02),
      child: ListTile(
        onTap: onTap,
        leading: leading,
        title: Text(title, style: titleStyle, textScaler: titleScaler),
        subtitle: subtitleWidget ??
            (subtitle != null ? Text(subtitle!, style: subtitleStyle) : null),
        trailing: trailing,
        isThreeLine: isThreeLine,
      ),
    );

    if (!hasActions) return content;

    final strings = AppStrings.of(context);
    return Slidable(
      key: ValueKey(title),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: actionExtentRatio,
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: editActionColor ?? ColorManager.primary,
              foregroundColor: actionForegroundColor ?? ColorManager.white,
              icon: editIcon ?? Icons.edit,
              label: editLabel ?? strings.edit,
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: deleteActionColor ?? ColorManager.error,
              foregroundColor: actionForegroundColor ?? ColorManager.white,
              icon: deleteIcon ?? Icons.delete,
              label: deleteLabel ?? strings.delete,
            ),
        ],
      ),
      child: content,
    );
  }
}
