import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;

  const TitleField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(AppRadius.r4),
          ),
          labelText: 'Title',
          hintText: 'Enter Title',
        ),
      ),
    );
  }
}
