import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

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
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        fillColor: Colors.grey[10],
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppWidth.w4,
          vertical: AppHeight.h12,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppRadius.r10),
          ),
        ),
      ),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      iconEnabledColor: ColorManager.blue,
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
