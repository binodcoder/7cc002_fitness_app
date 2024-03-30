import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final VoidCallback onTap;

  const CustomListTile({
    required Key key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      leading: leadingIcon != null
          ? Icon(
        leadingIcon,
        color: Theme.of(context).primaryColor,
      )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailingIcon != null
          ? Icon(
        trailingIcon,
        color: Theme.of(context).primaryColor,
      )
          : null,
    );
  }
}
