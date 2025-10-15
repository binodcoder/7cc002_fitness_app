import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'bear_log_in_controller.dart';
import 'tracking_text_input.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required this.controller,
    required this.isVisible,
    required this.onToggleVisibility,
    required this.bearController,
    required this.usernameCaret,
  });

  final TextEditingController controller;
  final bool isVisible;
  final VoidCallback onToggleVisibility;
  final BearLogInController bearController;
  final Offset? usernameCaret;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: getBoldStyle(
            fontSize: FontSize.s15,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: AppHeight.h8),
        TrackingTextInput(
          hint: 'Password',
          isObscured: !isVisible,
          textEditingController: controller,
          textInputAction: TextInputAction.done,
          suffix: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onToggleVisibility,
          ),
          onCaretMoved: (caret) {
            if (!isVisible) {
              // Hide the eyes while typing password
              bearController.coverEyes(caret != null);
              bearController.lookAt(null);
            } else {
              // When visible, look toward the last username caret (if any)
              bearController.coverEyes(usernameCaret == null);
              bearController.lookAt(usernameCaret);
            }
          },
        ),
      ],
    );
  }
}

