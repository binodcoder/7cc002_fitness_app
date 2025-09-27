import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Removed direct model import; page widget handles SliderObject usage
import 'package:fitness_app/core/assets/app_assets.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/features/onboarding/widgets/onboarding_slide.dart';
import 'package:fitness_app/features/onboarding/models/slider_object.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/config/backend_config.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  final SharedPreferences _prefs = sl<SharedPreferences>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _buildSlides(context);
    return _getContentWidget(slides);
  }

  List<SliderObject> _buildSlides(BuildContext context) {
    final strings = AppStrings.of(context);
    return [
      SliderObject(
        title: strings.onboardingTitle1,
        subTitle: strings.onboardingSubtitle1,
        image: ImageAssets.onBoardingLogo1,
      ),
      SliderObject(
        title: strings.onboardingTitle2,
        subTitle: strings.onboardingSubtitle2,
        image: ImageAssets.onBoardingLogo2,
      ),
      SliderObject(
        title: strings.onboardingTitle3,
        subTitle: strings.onboardingSubtitle3,
        image: ImageAssets.onBoardingLogo3,
      ),
      SliderObject(
        title: strings.onboardingTitle4,
        subTitle: strings.onboardingSubtitle4,
        image: ImageAssets.onBoardingLogo4,
      ),
    ];
  }

  Widget _getContentWidget(List<SliderObject> slides) {
    return Scaffold(
            backgroundColor: ColorManager.white,
            appBar: AppBar(
              backgroundColor: ColorManager.white,
              elevation: AppSize.s0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: ColorManager.white,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            body: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                //return OnBoarding Page
                return OnboardingSlide(
                  sliderObject: slides[index],
                );
              },
            ),
            bottomSheet: Container(
              color: ColorManager.white,
              height: AppSize.s100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _prefs.setBool('seen_onboarding', true);
                        if (BackendConfig.isFirebase &&
                            fb.FirebaseAuth.instance.currentUser == null) {
                          context.go(Routes.loginRoute);
                        } else {
                          context.go(Routes.routineRoute);
                        }
                      },
                      child: Text(
                        AppStrings.of(context).skip,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  //add layout for indicator and arrows
                  _getBottomSheetWidget(slides),
                ],
              ),
            ),
          );
  }

  Widget _getBottomSheetWidget(List<SliderObject> slides) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //left arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.leftArrow),
              ),
              onTap: () {
                //go to previous slide
                final prev = _currentIndex - 1 < 0
                    ? slides.length - 1
                    : _currentIndex - 1;
                _pageController.animateToPage(
                  prev,
                  duration: const Duration(milliseconds: DurationConstant.d300),
                  curve: Curves.bounceIn,
                );
                setState(() {
                  _currentIndex = prev;
                });
              },
            ),
          ),

          //circles indicator
          Row(
            children: [
              for (int i = 0; i < slides.length; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, _currentIndex),
                ),
            ],
          ),

          //right arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrow),
              ),
              onTap: () {
                //go to next slide or finish
                final isLast = _currentIndex == slides.length - 1;
                if (isLast) {
                  _prefs.setBool('seen_onboarding', true);
                  if (BackendConfig.isFirebase &&
                      fb.FirebaseAuth.instance.currentUser == null) {
                    context.go(Routes.loginRoute);
                  } else {
                    context.go(Routes.routineRoute);
                  }
                  return;
                }
                final next = _currentIndex + 1;
                _pageController.animateToPage(
                  next,
                  duration: const Duration(milliseconds: DurationConstant.d300),
                  curve: Curves.bounceIn,
                );
                setState(() {
                  _currentIndex = next;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircle); //selected slider
    } else {
      return SvgPicture.asset(ImageAssets.solidCircle); //unselected slider
    }
  }
}

// OnboardingSlide lives in widgets/onboarding_slide.dart
