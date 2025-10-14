import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final List<String> roles;
  final String selectedRole;
  final ValueChanged<String?> onChanged;

  const RoleDropdown({
    super.key,
    required this.roles,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      iconEnabledColor: scheme.primary,
      iconSize: 30,
      items: roles.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Container(
            margin: const EdgeInsets.only(left: 1),
            padding: const EdgeInsets.only(left: 10),
            height: 55,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(item),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      initialValue: selectedRole,
    );
  }
}
