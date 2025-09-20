// dart format width=120

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/R.png
  AssetGenImage get r => const AssetGenImage('assets/images/R.png');

  /// File path: assets/images/Teddy.flr
  String get teddy => 'assets/images/Teddy.flr';

  /// File path: assets/images/appicon.png
  AssetGenImage get appicon => const AssetGenImage('assets/images/appicon.png');

  /// File path: assets/images/appicon1.png
  AssetGenImage get appicon1 =>
      const AssetGenImage('assets/images/appicon1.png');

  /// File path: assets/images/appstore.png
  AssetGenImage get appstore =>
      const AssetGenImage('assets/images/appstore.png');

  /// File path: assets/images/exercise.svg
  String get exercise => 'assets/images/exercise.svg';

  /// File path: assets/images/hollow_circle_ic.svg
  String get hollowCircleIc => 'assets/images/hollow_circle_ic.svg';

  /// File path: assets/images/image.jpg
  AssetGenImage get image => const AssetGenImage('assets/images/image.jpg');

  /// File path: assets/images/left_arrow_ic.svg
  String get leftArrowIc => 'assets/images/left_arrow_ic.svg';

  /// File path: assets/images/noimage.jpg
  AssetGenImage get noimage => const AssetGenImage('assets/images/noimage.jpg');

  /// File path: assets/images/onboarding_logo1.svg
  String get onboardingLogo1 => 'assets/images/onboarding_logo1.svg';

  /// File path: assets/images/onboarding_logo2.svg
  String get onboardingLogo2 => 'assets/images/onboarding_logo2.svg';

  /// File path: assets/images/onboarding_logo3.svg
  String get onboardingLogo3 => 'assets/images/onboarding_logo3.svg';

  /// File path: assets/images/onboarding_logo4.svg
  String get onboardingLogo4 => 'assets/images/onboarding_logo4.svg';

  /// File path: assets/images/pic1.png
  AssetGenImage get pic1 => const AssetGenImage('assets/images/pic1.png');

  /// File path: assets/images/pic2.jpg
  AssetGenImage get pic2 => const AssetGenImage('assets/images/pic2.jpg');

  /// File path: assets/images/pic3.gif
  AssetGenImage get pic3Gif => const AssetGenImage('assets/images/pic3.gif');

  /// File path: assets/images/pic3.jpg
  AssetGenImage get pic3Jpg => const AssetGenImage('assets/images/pic3.jpg');

  /// File path: assets/images/pic4.jpg
  AssetGenImage get pic4 => const AssetGenImage('assets/images/pic4.jpg');

  /// File path: assets/images/pic5.jpg
  AssetGenImage get pic5 => const AssetGenImage('assets/images/pic5.jpg');

  /// File path: assets/images/right_arrow_ic.svg
  String get rightArrowIc => 'assets/images/right_arrow_ic.svg';

  /// File path: assets/images/solid_circle_ic.svg
  String get solidCircleIc => 'assets/images/solid_circle_ic.svg';

  /// File path: assets/images/splash.png
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.png');

  /// File path: assets/images/splash_logo.png
  AssetGenImage get splashLogo =>
      const AssetGenImage('assets/images/splash_logo.png');

  /// List of all assets
  List<dynamic> get values => [
        r,
        teddy,
        appicon,
        appicon1,
        appstore,
        exercise,
        hollowCircleIc,
        image,
        leftArrowIc,
        noimage,
        onboardingLogo1,
        onboardingLogo2,
        onboardingLogo3,
        onboardingLogo4,
        pic1,
        pic2,
        pic3Gif,
        pic3Jpg,
        pic4,
        pic5,
        rightArrowIc,
        solidCircleIc,
        splash,
        splashLogo
      ];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
