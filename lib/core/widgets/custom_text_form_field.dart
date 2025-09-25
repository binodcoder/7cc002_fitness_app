import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.minLines,
    this.maxLines,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.textInputAction,
    this.focusNode,
    this.autovalidateMode,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = widget.isPassword ? 1 : widget.maxLines;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: getBoldStyle(
            fontSize: FontSize.s15,
            color: ColorManager.primary,
          ),
        ),
        SizedBox(height: AppHeight.h10),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          minLines: widget.minLines,
          maxLines: effectiveMaxLines,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          autovalidateMode: widget.autovalidateMode,
          enabled: widget.enabled,
          obscureText: widget.isPassword ? !_visible : false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: ColorManager.redWhite,
            filled: true,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _visible ? Icons.visibility : Icons.visibility_off,
                      color: ColorManager.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                  )
                : widget.suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorManager.blueGrey),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorManager.primary),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorManager.red),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
          ),
        ),
      ],
    );
  }
}
