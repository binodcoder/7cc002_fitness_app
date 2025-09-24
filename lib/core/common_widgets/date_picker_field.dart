import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final double height;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: TextFormField(
          style: const TextStyle(fontSize: 40),
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

