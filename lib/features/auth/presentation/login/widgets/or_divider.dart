import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.h10),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
            child: Text(
              'Or continue with',
              style: getRegularStyle(
                fontSize: FontSize.s14,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(178),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

