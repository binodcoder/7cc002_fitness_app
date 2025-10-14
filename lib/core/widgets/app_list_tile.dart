import 'package:flutter/material.dart';

/// A consistent, themed list tile wrapped in a Card with spacing.
/// Matches the app's card theme, supports dark mode, and keeps API simple.
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final bool isThreeLine;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.margin,
    this.contentPadding,
    this.isThreeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: theme.cardColor,
      child: ListTile(
        leading: leading,
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: subtitle != null
            ? Text(subtitle!, style: theme.textTheme.bodySmall)
            : null,
        trailing: trailing,
        onTap: onTap,
        isThreeLine: isThreeLine,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
