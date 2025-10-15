import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'bear_log_in_controller.dart';
import 'tracking_text_input.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({
    super.key,
    required this.controller,
    required this.bearController,
    required this.onCaretChanged,
  });

  final TextEditingController controller;
  final BearLogInController bearController;
  final ValueChanged<Offset?> onCaretChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppHeight.h10),
        Text(
          'UserName',
          style: getBoldStyle(
            fontSize: FontSize.s15,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: AppHeight.h8),
        TrackingTextInput(
          hint: 'UserName',
          textEditingController: controller,
          isObscured: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          suffix: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
              size: FontSize.s20,
            ),
          ),
          onCaretMoved: (caret) {
            onCaretChanged(caret);
            bearController.coverEyes(caret == null);
            bearController.lookAt(caret);
          },
        ),
      ],
    );
  }
}

