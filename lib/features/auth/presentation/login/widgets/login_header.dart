import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

import 'bear_log_in_controller.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.controller,
  });

  final BearLogInController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Text(
            'Fitness App',
            style: getBoldStyle(
              fontSize: FontSize.s30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        Container(
          height: size.height * 0.16,
          padding: EdgeInsets.only(left: AppWidth.w30, right: AppWidth.w30),
          child: FlareActor(
            'assets/images/Teddy.flr',
            shouldClip: false,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.contain,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
