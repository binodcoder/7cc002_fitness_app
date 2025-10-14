import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final BorderRadius borderRadius;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50.0,
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(25.0)),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: gradient ??
            LinearGradient(
              colors: <Color>[
                scheme.primary,
                scheme.primary.withAlpha(216),
              ],
            ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Center(child: child),
        ),
      ),
    );
  }
}
