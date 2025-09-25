import 'package:flutter/material.dart';

import 'package:fitness_app/features/onboarding/models/slider_object.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class OnboardingSlide extends StatelessWidget {
  final SliderObject sliderObject;

  const OnboardingSlide({
    super.key,
    required this.sliderObject,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSize.s10),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSize.s60),
        SizedBox(
          width: size.width,
          height: size.height * 0.3,
          child: ClipRRect(
            child: SizedBox(
              width: size.width,
              height: size.height * 0.3,
              child: Image.asset(
                sliderObject.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
