import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fitness App'**
  String get appTitle;

  /// No description provided for @noRouteFound.
  ///
  /// In en, this message translates to:
  /// **'No Route Found'**
  String get noRouteFound;

  /// No description provided for @titleRoutine.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get titleRoutine;

  /// No description provided for @titleWalk.
  ///
  /// In en, this message translates to:
  /// **'Purposed Walks'**
  String get titleWalk;

  /// No description provided for @titleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get titleAppointment;

  /// No description provided for @titleWalkMedia.
  ///
  /// In en, this message translates to:
  /// **'Walk Media'**
  String get titleWalkMedia;

  /// No description provided for @titleLiveTraining.
  ///
  /// In en, this message translates to:
  /// **'Live Trainings'**
  String get titleLiveTraining;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @updateUser.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateUser;

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointment;

  /// No description provided for @addLiveTraining.
  ///
  /// In en, this message translates to:
  /// **'Add Live Training'**
  String get addLiveTraining;

  /// No description provided for @addRoutine.
  ///
  /// In en, this message translates to:
  /// **'Add Routine'**
  String get addRoutine;

  /// No description provided for @updateRoutine.
  ///
  /// In en, this message translates to:
  /// **'Update Routine'**
  String get updateRoutine;

  /// No description provided for @addWalk.
  ///
  /// In en, this message translates to:
  /// **'Add Walk'**
  String get addWalk;

  /// No description provided for @updateWalk.
  ///
  /// In en, this message translates to:
  /// **'Update Walk'**
  String get updateWalk;

  /// No description provided for @addWalkMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Walk Media'**
  String get addWalkMedia;

  /// No description provided for @updateWalkMedia.
  ///
  /// In en, this message translates to:
  /// **'Update Walk Media'**
  String get updateWalkMedia;

  /// No description provided for @routineDetails.
  ///
  /// In en, this message translates to:
  /// **'Routine Details'**
  String get routineDetails;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// No description provided for @pickGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick Gallery'**
  String get pickGallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @serverFailure.
  ///
  /// In en, this message translates to:
  /// **'Server Failure'**
  String get serverFailure;

  /// No description provided for @cacheFailure.
  ///
  /// In en, this message translates to:
  /// **'Cache Failure'**
  String get cacheFailure;

  /// No description provided for @loginFailure.
  ///
  /// In en, this message translates to:
  /// **'Invalid Username or Password'**
  String get loginFailure;

  /// No description provided for @invalidInputFailure.
  ///
  /// In en, this message translates to:
  /// **'Invalid Input - The number must be a positive integer.'**
  String get invalidInputFailure;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'FITNESS CONTENT'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'LIVE TRAINING'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'APPOINTMENT'**
  String get onboardingTitle3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'WALK FEATURE'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'The app provides pre-loaded fitness routines'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Users can join real-time workout sessions led by either group trainers or book individual trainers'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'A calendar feature for users to schedule one-on-one sessions with personal trainers'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Users can design routes on a map, set times, and starting points. Others can view and express interest in joining'**
  String get onboardingSubtitle4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
