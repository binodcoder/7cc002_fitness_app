import 'package:fitness_app/gen/assets.gen.dart';

class AppAssets {
  const AppAssets._();

  static $AssetsImagesGen get images => Assets.images;
}

class ImageAssets {
  const ImageAssets._();

  static String get background => Assets.images.image.path;
  static String get splashLogo => Assets.images.r.path;
  static String get onBoardingLogo1 => Assets.images.pic1.path;
  static String get onBoardingLogo2 => Assets.images.pic3Gif.path;
  static String get onBoardingLogo3 => Assets.images.pic5.path;
  static String get onBoardingLogo4 => Assets.images.pic4.path;
  static String get hollowCircle => Assets.images.hollowCircleIc;
  static String get leftArrow => Assets.images.leftArrowIc;
  static String get rightArrow => Assets.images.rightArrowIc;
  static String get solidCircle => Assets.images.solidCircleIc;
}
