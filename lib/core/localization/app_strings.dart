import 'package:flutter/widgets.dart';

import '../../../l10n/app_localizations.dart';

class AppStrings {
  const AppStrings._(this._localizations);

  final AppLocalizations? _localizations;

  static AppStrings of(BuildContext context) {
    return AppStrings._(AppLocalizations.of(context));
  }

  String get appTitle => _localizations?.appTitle ?? AppStringsEn.appTitle;
  String get noRouteFound =>
      _localizations?.noRouteFound ?? AppStringsEn.noRouteFound;
  String get titleRoutine =>
      _localizations?.titleRoutine ?? AppStringsEn.titleRoutine;
  String get titleRoutineLabel => titleRoutine;
  String get titleWalk => _localizations?.titleWalk ?? AppStringsEn.titleWalk;
  String get titleWalkLabel => titleWalk;
  String get titleAppointment =>
      _localizations?.titleAppointment ?? AppStringsEn.titleAppointment;
  String get titleAppointmentLabel => titleAppointment;
  String get titleWalkMedia =>
      _localizations?.titleWalkMedia ?? AppStringsEn.titleWalkMedia;
  String get titleWalkMediaLabel => titleWalkMedia;
  String get titleLiveTraining =>
      _localizations?.titleLiveTraining ?? AppStringsEn.titleLiveTraining;
  String get titleLiveTrainingLabel => titleLiveTraining;
  String get title => _localizations?.title ?? AppStringsEn.title;
  String get content => _localizations?.content ?? AppStringsEn.content;
  String get imageUrl => _localizations?.imageUrl ?? AppStringsEn.imageUrl;
  String get register => _localizations?.register ?? AppStringsEn.register;
  String get updateUser =>
      _localizations?.updateUser ?? AppStringsEn.updateUser;
  String get addAppointment =>
      _localizations?.addAppointment ?? AppStringsEn.addAppointment;
  String get addAppointments => addAppointment;
  String get addLiveTraining =>
      _localizations?.addLiveTraining ?? AppStringsEn.addLiveTraining;
  String get addRoutine =>
      _localizations?.addRoutine ?? AppStringsEn.addRoutine;
  String get updateRoutine =>
      _localizations?.updateRoutine ?? AppStringsEn.updateRoutine;
  String get addWalk => _localizations?.addWalk ?? AppStringsEn.addWalk;
  String get updateWalk =>
      _localizations?.updateWalk ?? AppStringsEn.updateWalk;
  String get addWalkMedia =>
      _localizations?.addWalkMedia ?? AppStringsEn.addWalkMedia;
  String get updateWalkMedia =>
      _localizations?.updateWalkMedia ?? AppStringsEn.updateWalkMedia;
  String get routineDetails =>
      _localizations?.routineDetails ?? AppStringsEn.routineDetails;
  String get error => _localizations?.error ?? AppStringsEn.error;
  String get edit => _localizations?.edit ?? AppStringsEn.edit;
  String get delete => _localizations?.delete ?? AppStringsEn.delete;
  String get editPost => _localizations?.editPost ?? AppStringsEn.editPost;
  String get cancel => _localizations?.cancel ?? AppStringsEn.cancel;
  String get save => _localizations?.save ?? AppStringsEn.save;
  String get walk => _localizations?.walk ?? AppStringsEn.walk;
  String get pickGallery =>
      _localizations?.pickGallery ?? AppStringsEn.pickGallery;
  String get pickGalary => pickGallery;
  String get camera => _localizations?.camera ?? AppStringsEn.camera;
  String get serverFailure =>
      _localizations?.serverFailure ?? AppStringsEn.serverFailure;
  String get cacheFailure =>
      _localizations?.cacheFailure ?? AppStringsEn.cacheFailure;
  String get loginFailure =>
      _localizations?.loginFailure ?? AppStringsEn.loginFailure;
  String get invalidInputFailure =>
      _localizations?.invalidInputFailure ?? AppStringsEn.invalidInputFailure;
  String get onboardingTitle1 =>
      _localizations?.onboardingTitle1 ?? AppStringsEn.onboardingTitle1;
  String get onboardingTitle2 =>
      _localizations?.onboardingTitle2 ?? AppStringsEn.onboardingTitle2;
  String get onboardingTitle3 =>
      _localizations?.onboardingTitle3 ?? AppStringsEn.onboardingTitle3;
  String get onboardingTitle4 =>
      _localizations?.onboardingTitle4 ?? AppStringsEn.onboardingTitle4;
  String get onboardingSubtitle1 =>
      _localizations?.onboardingSubtitle1 ?? AppStringsEn.onboardingSubtitle1;
  String get onboardingSubtitle2 =>
      _localizations?.onboardingSubtitle2 ?? AppStringsEn.onboardingSubtitle2;
  String get onboardingSubtitle3 =>
      _localizations?.onboardingSubtitle3 ?? AppStringsEn.onboardingSubtitle3;
  String get onboardingSubtitle4 =>
      _localizations?.onboardingSubtitle4 ?? AppStringsEn.onboardingSubtitle4;
  String get skip => _localizations?.skip ?? AppStringsEn.skip;
  // These keys are not in generated AppLocalizations yet; fallback to English.
  String get logOut => AppStringsEn.logOut;
  String get aboutUs => AppStringsEn.aboutUs;
  String get meeting => AppStringsEn.meeting;
  String get chat => AppStringsEn.chat;
}

class AppStringsEn {
  const AppStringsEn._();

  static const String appTitle = 'Fitness App';
  static const String noRouteFound = 'No Route Found';
  static const String titleRoutine = 'Routines';
  static const String titleWalk = 'Purposed Walks';
  static const String titleAppointment = 'Appointments';
  static const String titleWalkMedia = 'Walk Media';
  static const String titleLiveTraining = 'Live Trainings';
  static const String title = 'Title';
  static const String content = 'Content';
  static const String imageUrl = 'Image URL';
  static const String register = 'Register';
  static const String updateUser = 'Update';
  static const String addAppointment = 'Add Appointment';
  static const String addLiveTraining = 'Add Live Training';
  static const String addRoutine = 'Add Routine';
  static const String updateRoutine = 'Update Routine';
  static const String addWalk = 'Add Walk';
  static const String updateWalk = 'Update Walk';
  static const String addWalkMedia = 'Add Walk Media';
  static const String updateWalkMedia = 'Update Walk Media';
  static const String routineDetails = 'Routine Details';
  static const String error = 'Error';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String editPost = 'Edit Post';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String walk = 'Walk';
  static const String pickGallery = 'Pick Gallery';
  static const String camera = 'Camera';
  static const String serverFailure = 'Server Failure';
  static const String cacheFailure = 'Cache Failure';
  static const String loginFailure = 'Invalid Username or Password';
  static const String invalidInputFailure =
      'Invalid Input - The number must be a positive integer.';
  static const String onboardingTitle1 = 'FITNESS CONTENT';
  static const String onboardingTitle2 = 'LIVE TRAINING';
  static const String onboardingTitle3 = 'APPOINTMENT';
  static const String onboardingTitle4 = 'WALK FEATURE';
  static const String onboardingSubtitle1 =
      'The app provides pre-loaded fitness routines';
  static const String onboardingSubtitle2 =
      'Users can join real-time workout sessions led by either group trainers or book individual trainers';
  static const String onboardingSubtitle3 =
      'A calendar feature for users to schedule one-on-one sessions with personal trainers';
  static const String onboardingSubtitle4 =
      'Users can design routes on a map, set times, and starting points. Others can view and express interest in joining';
  static const String skip = 'Skip';
  static const String logOut = 'Log out';
  static const String aboutUs = 'About Us';
  static const String meeting = 'Meeting';
  static const String chat = 'Chat';
}
