import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double height;
  final VoidCallback onTap;

  const TimePickerField({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: scheme.surfaceContainerHighest),
        child: TextFormField(
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: controller,
          decoration: const InputDecoration(
            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.only(top: 0.0),
          ),
        ),
      ),
    );
  }
}
