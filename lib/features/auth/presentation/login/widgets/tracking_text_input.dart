import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fitness_app/core/util/global_declaration.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'input_helper.dart';

class TrackingTextInput extends StatefulWidget {
  const TrackingTextInput({
    Key? key,
    this.onCaretMoved,
    this.onTextChanged,
    this.hint,
    required this.isObscured,
    required this.textEditingController,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onFieldSubmitted,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.enabled,
  }) : super(key: key);

  final CaretMoved? onCaretMoved;
  final TextChanged? onTextChanged;
  final String? hint;

  final bool isObscured;
  final TextEditingController textEditingController;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? focusNode;
  final bool? enabled;

  @override
  State<TrackingTextInput> createState() => _TrackingTextInputState();
}

class _TrackingTextInputState extends State<TrackingTextInput> {
  final GlobalKey _fieldKey = GlobalKey();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (_fieldKey.currentContext != null) {
          final RenderObject? fieldBox =
              _fieldKey.currentContext?.findRenderObject();
          var caretPosition =
              fieldBox is RenderBox ? getCaretPosition(fieldBox) : null;

          widget.onCaretMoved?.call(caretPosition);
        }
      });
      widget.onTextChanged?.call(widget.textEditingController.text);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppHeight.h20),
      child: TextFormField(
        key: _fieldKey,
        focusNode: widget.focusNode,
        controller: widget.textEditingController,
        obscureText: widget.isObscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onFieldSubmitted: widget.onFieldSubmitted,
        enabled: widget.enabled,
        validator: widget.validator ?? (value) {
          if (value == null || value.isEmpty) {
            return '*Required';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.prefix,
          suffixIcon: widget.suffix,
          fillColor: ColorManager.redWhite,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppRadius.r10),
          ),
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
    );
  }
}
