import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class TextAreaField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final int minLines;
  final int maxLines;

  const TextAreaField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.minLines = 2,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        maxLines: maxLines,
        minLines: minLines,
        controller: controller,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.blue),
            borderRadius: BorderRadius.circular(AppRadius.r4),
          ),
          labelText: labelText,
          hintText: hintText,
        ),
      ),
    );
  }
}

